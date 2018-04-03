#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

/***************************************************************************
Map Vote Menu Mod
Created by |UzD|GaZa
Site / Support: http://www.uzd-zombies.com/viewtopic.php?f=29&t=33

Based on vote system 1.0 by banz
Although now heavily edited/updated for use with a mouse UI by |UzD|GaZa
**************************************************************************/

/***************************************************************************
** Release Notes:
** First Release (30/05/2014):[/u]
**	-Added vote menu file
**	-Added menu support for banz voting gsc
** 
** Update 0.5.0 (29/06/2017)
**	-Added support for iw4x 0.5.0
**	-Added support for voting on custom maps
**	-Added failsafe for 'sv_votemaps'
**
** Update 0.5.3 (04/07/2017)
**	-Added support for iw4x 0.5.3
**	-Votes no longer run on a loop, now when users call
**	-Mod is now standalone so works with all mods
**
** Update 0.5.4 (09/07/2017)
**	-Added support for iw4x 0.5.4
**	-Added game type vote support
**
** Update 0.5.4-r2 (20/07/2017)
**	-Cleaned the UI a little,
**		removed some jaggy edges from map previews etc.
**		Also bigger selected vote border
**	-Better support for 4:3 resolutions
*************************************************************************/

init(standalone, maps, gametypes, votetime, winnertime)
{
	/**********INIT CHECKS************************************************************/
	level.inVote = undefined;//Undefined here to catch errors later relating to non-standalone
	if(!isDefined(standalone))
		standalone = true;//Default to true
	if(!isDefined(votetime) || (isDefined(votetime) && votetime < 0))
		votetime = 0;
	if(!isDefined(winnertime) || (isDefined(winnertime) && winnertime < 0))
		winnertime = 0;
		
	//Do not run if the vote times exceed 30 seconds for a dedicated server.
	if(!getDvarInt( "party_host" ) && (votetime + winnertime > 30) && standalone)
	{
		logPrint("Vote Mod: Not loaded, dedicated server vote times exceed 30 seconds. Check scripts\vote.gsc\n");
		return;
	}
	//Do not run if the vote times exceed 10 seconds for a private match.
	else if(getDvarInt( "party_host" ) && (votetime + winnertime > 10) && standalone)
	{
		logPrint("Vote Mod: Not loaded, private match vote times exceed 10 seconds. Check scripts\vote.gsc\n");
		return;
	}
	else if(!votetime || !winnertime)
	{
		logPrint("Vote Mod: Not loaded, no/incorrect vote times given.  Check scripts\vote.gsc\n");
		return;
	}
	//Do not run on a party server as there is no intermission
	else if(matchmakingGame() && standalone)
	{
		logPrint("Vote Mod: Not loaded, incompatible with a party server. Read how to disable standalone in scripts\vote.gsc\n");
		return;
	}
	else
		logPrint("Vote Mod: Loaded Successfully.\n");
	/****************************************************************************/
	
	/***DVARS************************************************************/
	//Maps
	if(!isDefined(maps))
		maps = "";
	setDvarIfUninitialized( "sv_votemaps", maps);
	
	//Game Modes
	if(!isDefined(gametypes))
		gametypes = "";
	setDvarIfUninitialized( "sv_gametypes", gametypes);
	
	level.VoteVoteTime = int(votetime); //Time available to vote
	level.VoteWinnerTime = int(winnertime); //Time the winning map is displayed for
	/****************************************************************************/
	
	/****METHODS************************************************************/
	CreateStockMapArray();//Add stock iw4x maps
	level thread onPlayerConnect();//Player connect
	if(standalone)
		level thread monitorIntermission();//Wait for intermission to start before injecting vote mod- Standalone (e.g no gamelogic.gsc)
	/****************************************************************************/
	
	/*****DEFINE MENU************************************************************/
	game["menu_vote"] = "vote";
	precacheMenu(game["menu_vote"]);
	/****************************************************************************/
	
	/*****SETUP VOTE MAPS************************************************************/
	level.inVote = false;
	level.VotePosition = undefined;
	
	/******************MAPS*******************************/
	level.mapTok = [];//Store Vote Maps
	level.mapVotes = [];//Store Votes for each map
	level.voteMaps = "";
	level.voteMaps = getDvar( "sv_votemaps" );
	
	if(level.voteMaps == "")//If the user hasnt entered any maps into 'sv_votemaps', set vote to default iw4x ones
	{
		stockmaps = getArrayKeys( level.iw4xmaps );	
		for(i=0;i<stockmaps.size;i++)
			level.mapTok[i] = stockmaps[i];
		logPrint("Vote Mod: No maps specified in vote.gsc, setting to default.\n");
	}
	else if(strTok( level.voteMaps, "," ).size < 9)//If the user has entered maps although under 9 add some from stock iw4x.
	{
		level.mapTok = strTok( level.voteMaps, "," );
		
		stockmaps = getArrayKeys( level.iw4xmaps );
		for(i=level.mapTok.size;i<9;i++)
			level.mapTok[i] = stockmaps[i];
			
		logPrint("Vote Mod: Not enough maps specified in vote.gsc, adding some default maps.\n");
	}
	else//As above 9 maps entered use the sv_votemaps
	{
		level.mapTok = strTok( level.voteMaps, "," );
	}
	
    randomArray = [];
    for(i = 0; i < 9; i++)
	{
		selectedRand = randomintrange(0, level.mapTok.size);
        randomArray[i] = level.mapTok[selectedRand];
        level.mapTok = restructMapArray(level.mapTok, selectedRand);
    }
	
    level.mapTok = randomArray;
	for( i=0; i < level.mapTok.size; i++ )
	{
		level.mapVotes[i] = 0;
	}
	/****************************************************************************/
	
	/**********************GAME MODES********************************************/		
	level.votegametypes = "";
	level.votegametypes = getDvar( "sv_gametypes" );
	if(level.votegametypes != "")
	{
		level.gamemodeTok = [];
		level.gamemodeTok = strTok( level.votegametypes, "," );
		
		randomGametypeArray = [];
		for(i=0;i<9;i++)
			randomGametypeArray[i] = level.gamemodeTok[randomintrange(0,level.gamemodeTok.size)];
		level.gamemodeTok = randomGametypeArray;
	}
	else//If the user hasn't entered any game modes into 'sv_gametypes' just use g_gametype
		return;
	/***************************************************************************/
}

CreateStockMapArray()
{
	level.iw4xmaps = [];
	
	level.iw4xmaps["afghan"] = [];
	level.iw4xmaps["afghan"]["localised_name"] = "Afghan";
	level.iw4xmaps["afghan"]["preview_name"] = "preview_mp_afghan";
	level.iw4xmaps["afghan"]["zone_name"] = "mp_afghan";
	
	level.iw4xmaps["bailout"] = [];
	level.iw4xmaps["bailout"]["localised_name"] = "Bailout";
	level.iw4xmaps["bailout"]["preview_name"] = "preview_mp_complex";
	level.iw4xmaps["bailout"]["zone_name"] = "mp_complex";
	
	level.iw4xmaps["bloc"] = [];
	level.iw4xmaps["bloc"]["localised_name"] = "Bloc";
	level.iw4xmaps["bloc"]["preview_name"] = "preview_mp_bloc";
	level.iw4xmaps["bloc"]["zone_name"] = "mp_bloc";
	
	level.iw4xmaps["bog"] = [];
	level.iw4xmaps["bog"]["localised_name"] = "Bog";
	level.iw4xmaps["bog"]["preview_name"] = "preview_mp_bog_sh";
	level.iw4xmaps["bog"]["zone_name"] = "mp_bog_sh";
	
	level.iw4xmaps["carnival"] = [];
	level.iw4xmaps["carnival"]["localised_name"] = "Carnival";
	level.iw4xmaps["carnival"]["preview_name"] = "preview_mp_abandon";
	level.iw4xmaps["carnival"]["zone_name"] = "mp_abandon";
	
	level.iw4xmaps["chemicalplant"] = [];
	level.iw4xmaps["chemicalplant"]["localised_name"] = "Chemical Plant";
	level.iw4xmaps["chemicalplant"]["preview_name"] = "preview_mp_storm_spring";
	level.iw4xmaps["chemicalplant"]["zone_name"] = "mp_storm_spring";
	
	level.iw4xmaps["crash"] = [];
	level.iw4xmaps["crash"]["localised_name"] = "Crash";
	level.iw4xmaps["crash"]["preview_name"] = "preview_mp_crash";
	level.iw4xmaps["crash"]["zone_name"] = "mp_crash";
	
	level.iw4xmaps["crashtropical"] = [];
	level.iw4xmaps["crashtropical"]["localised_name"] = "Crash: Tropical";
	level.iw4xmaps["crashtropical"]["preview_name"] = "preview_mp_crash_tropical";
	level.iw4xmaps["crashtropical"]["zone_name"] = "mp_crash_tropical";
	
	level.iw4xmaps["crossfire"] = [];
	level.iw4xmaps["crossfire"]["localised_name"] = "Crossfire";
	level.iw4xmaps["crossfire"]["preview_name"] = "preview_mp_cross_fire";
	level.iw4xmaps["crossfire"]["zone_name"] = "mp_cross_fire";
	
	level.iw4xmaps["derail"] = [];
	level.iw4xmaps["derail"]["localised_name"] = "Derail";
	level.iw4xmaps["derail"]["preview_name"] = "preview_mp_derail";
	level.iw4xmaps["derail"]["zone_name"] = "mp_derail";
	
	level.iw4xmaps["estate"] = [];
	level.iw4xmaps["estate"]["localised_name"] = "Estate";
	level.iw4xmaps["estate"]["preview_name"] = "preview_mp_estate";
	level.iw4xmaps["estate"]["zone_name"] = "mp_estate";
	
	level.iw4xmaps["estatetropical"] = [];
	level.iw4xmaps["estatetropical"]["localised_name"] = "Estate: Tropical";
	level.iw4xmaps["estatetropical"]["preview_name"] = "preview_mp_estate_tropical";
	level.iw4xmaps["estatetropical"]["zone_name"] = "mp_estate_tropical";
	
	level.iw4xmaps["favela"] = [];
	level.iw4xmaps["favela"]["localised_name"] = "Favela";
	level.iw4xmaps["favela"]["preview_name"] = "preview_mp_favela";
	level.iw4xmaps["favela"]["zone_name"] = "mp_favela";
	
	level.iw4xmaps["favelatropical"] = [];
	level.iw4xmaps["favelatropical"]["localised_name"] = "Favela: Tropical";
	level.iw4xmaps["favelatropical"]["preview_name"] = "preview_mp_fav_tropical";
	level.iw4xmaps["favelatropical"]["zone_name"] = "mp_fav_tropical";
	
	level.iw4xmaps["firingrange"] = [];
	level.iw4xmaps["firingrange"]["localised_name"] = "Firing Range";
	level.iw4xmaps["firingrange"]["preview_name"] = "preview_mp_firingrange";
	level.iw4xmaps["firingrange"]["zone_name"] = "mp_firingrange";
	
	level.iw4xmaps["forgottencity"] = [];
	level.iw4xmaps["forgottencity"]["localised_name"] = "Forgotten City";
	level.iw4xmaps["forgottencity"]["preview_name"] = "preview_mp_bloc_sh";
	level.iw4xmaps["forgottencity"]["zone_name"] = "mp_bloc_sh";
	
	level.iw4xmaps["freighter"] = [];
	level.iw4xmaps["freighter"]["localised_name"] = "Freighter";
	level.iw4xmaps["freighter"]["preview_name"] = "preview_mp_cargoship_sh";
	level.iw4xmaps["freighter"]["zone_name"] = "mp_cargoship_sh";
	
	level.iw4xmaps["fuel"] = [];
	level.iw4xmaps["fuel"]["localised_name"] = "Fuel";
	level.iw4xmaps["fuel"]["preview_name"] = "preview_mp_fuel2";
	level.iw4xmaps["fuel"]["zone_name"] = "mp_fuel2";
	
	level.iw4xmaps["highrise"] = [];
	level.iw4xmaps["highrise"]["localised_name"] = "Highrise";
	level.iw4xmaps["highrise"]["preview_name"] = "preview_mp_highrise";
	level.iw4xmaps["highrise"]["zone_name"] = "mp_highrise";
	
	level.iw4xmaps["invasion"] = [];
	level.iw4xmaps["invasion"]["localised_name"] = "Invasion";
	level.iw4xmaps["invasion"]["preview_name"] = "preview_mp_invasion";
	level.iw4xmaps["invasion"]["zone_name"] = "mp_invasion";
	
	level.iw4xmaps["karachi"] = [];
	level.iw4xmaps["karachi"]["localised_name"] = "Karachi";
	level.iw4xmaps["karachi"]["preview_name"] = "preview_mp_checkpoint";
	level.iw4xmaps["karachi"]["zone_name"] = "mp_checkpoint";

	level.iw4xmaps["killhouse"] = [];
	level.iw4xmaps["killhouse"]["localised_name"] = "Killhouse";
	level.iw4xmaps["killhouse"]["preview_name"] = "preview_mp_killhouse";
	level.iw4xmaps["killhouse"]["zone_name"] = "mp_killhouse";
	
	level.iw4xmaps["nuketown"] = [];
	level.iw4xmaps["nuketown"]["localised_name"] = "Nuketown";
	level.iw4xmaps["nuketown"]["preview_name"] = "preview_mp_nuked";
	level.iw4xmaps["nuketown"]["zone_name"] = "mp_nuked";
	
	level.iw4xmaps["oilrig"] = [];
	level.iw4xmaps["oilrig"]["localised_name"] = "Oil Rig";
	level.iw4xmaps["oilrig"]["preview_name"] = "preview_oilrig";
	level.iw4xmaps["oilrig"]["zone_name"] = "oilrig";
	
	level.iw4xmaps["overgrown"] = [];
	level.iw4xmaps["overgrown"]["localised_name"] = "Overgrown";
	level.iw4xmaps["overgrown"]["preview_name"] = "preview_mp_overgrown";
	level.iw4xmaps["overgrown"]["zone_name"] = "mp_overgrown";
	
	level.iw4xmaps["quarry"] = [];
	level.iw4xmaps["quarry"]["localised_name"] = "Quarry";
	level.iw4xmaps["quarry"]["preview_name"] = "preview_mp_quarry";
	level.iw4xmaps["quarry"]["zone_name"] = "mp_quarry";
	
	level.iw4xmaps["rundown"] = [];
	level.iw4xmaps["rundown"]["localised_name"] = "Rundown";
	level.iw4xmaps["rundown"]["preview_name"] = "preview_mp_rundown";
	level.iw4xmaps["rundown"]["zone_name"] = "mp_rundown";
	
	level.iw4xmaps["rust"] = [];
	level.iw4xmaps["rust"]["localised_name"] = "Rust";
	level.iw4xmaps["rust"]["preview_name"] = "preview_mp_rust";
	level.iw4xmaps["rust"]["zone_name"] = "mp_rust";
	
	level.iw4xmaps["rustlong"] = [];
	level.iw4xmaps["rustlong"]["localised_name"] = "Rust: Long";
	level.iw4xmaps["rustlong"]["preview_name"] = "preview_mp_rust_long";
	level.iw4xmaps["rustlong"]["zone_name"] = "mp_rust_long";
	
	level.iw4xmaps["salvage"] = [];
	level.iw4xmaps["salvage"]["localised_name"] = "Salvage";
	level.iw4xmaps["salvage"]["preview_name"] = "preview_mp_compact";
	level.iw4xmaps["salvage"]["zone_name"] = "mp_compact";
	
	level.iw4xmaps["scrapyard"] = [];
	level.iw4xmaps["scrapyard"]["localised_name"] = "Scrapyard";
	level.iw4xmaps["scrapyard"]["preview_name"] = "preview_mp_boneyard";
	level.iw4xmaps["scrapyard"]["zone_name"] = "mp_boneyard";
	
	level.iw4xmaps["shipment"] = [];
	level.iw4xmaps["shipment"]["localised_name"] = "Shipment";
	level.iw4xmaps["shipment"]["preview_name"] = "preview_mp_shipment";
	level.iw4xmaps["shipment"]["zone_name"] = "mp_shipment";
	
	level.iw4xmaps["shipmentlong"] = [];
	level.iw4xmaps["shipmentlong"]["localised_name"] = "Shipment: Long";
	level.iw4xmaps["shipmentlong"]["preview_name"] = "preview_mp_shipment_long";
	level.iw4xmaps["shipmentlong"]["zone_name"] = "mp_shipment_long";
	
	level.iw4xmaps["skidrow"] = [];
	level.iw4xmaps["skidrow"]["localised_name"] = "Skidrow";
	level.iw4xmaps["skidrow"]["preview_name"] = "preview_mp_nightshift";
	level.iw4xmaps["skidrow"]["zone_name"] = "mp_nightshift";

	level.iw4xmaps["storm"] = [];
	level.iw4xmaps["storm"]["localised_name"] = "Storm";
	level.iw4xmaps["storm"]["preview_name"] = "preview_mp_storm";
	level.iw4xmaps["storm"]["zone_name"] = "mp_storm";
	
	level.iw4xmaps["strike"] = [];
	level.iw4xmaps["strike"]["localised_name"] = "Strike";
	level.iw4xmaps["strike"]["preview_name"] = "preview_mp_strike";
	level.iw4xmaps["strike"]["zone_name"] = "mp_strike";
	
	level.iw4xmaps["subbase"] = [];
	level.iw4xmaps["subbase"]["localised_name"] = "Sub Base";
	level.iw4xmaps["subbase"]["preview_name"] = "preview_mp_subbase";
	level.iw4xmaps["subbase"]["zone_name"] = "mp_subbase";
	
	level.iw4xmaps["terminal"] = [];
	level.iw4xmaps["terminal"]["localised_name"] = "Terminal";
	level.iw4xmaps["terminal"]["preview_name"] = "preview_mp_terminal";
	level.iw4xmaps["terminal"]["zone_name"] = "mp_terminal";
	
	level.iw4xmaps["trailerpark"] = [];
	level.iw4xmaps["trailerpark"]["localised_name"] = "Trailer Park";
	level.iw4xmaps["trailerpark"]["preview_name"] = "preview_mp_trailerpark";
	level.iw4xmaps["trailerpark"]["zone_name"] = "mp_trailerpark";
	
	level.iw4xmaps["underpass"] = [];
	level.iw4xmaps["underpass"]["localised_name"] = "Underpass";
	level.iw4xmaps["underpass"]["preview_name"] = "preview_mp_underpass";
	level.iw4xmaps["underpass"]["zone_name"] = "mp_underpass";
	
	level.iw4xmaps["vacant"] = [];
	level.iw4xmaps["vacant"]["localised_name"] = "Vacant";
	level.iw4xmaps["vacant"]["preview_name"] = "preview_mp_vacant";
	level.iw4xmaps["vacant"]["zone_name"] = "mp_vacant";
	
	level.iw4xmaps["village"] = [];
	level.iw4xmaps["village"]["localised_name"] = "Village";
	level.iw4xmaps["village"]["preview_name"] = "preview_favela_escape";
	level.iw4xmaps["village"]["zone_name"] = "favela_escape";

	level.iw4xmaps["wasteland"] = [];
	level.iw4xmaps["wasteland"]["localised_name"] = "Wasteland";
	level.iw4xmaps["wasteland"]["preview_name"] = "preview_mp_brecourt";
	level.iw4xmaps["wasteland"]["zone_name"] = "mp_brecourt";
	
	level.iw4xmaps["wetwork"] = [];
	level.iw4xmaps["wetwork"]["localised_name"] = "Wet Work";
	level.iw4xmaps["wetwork"]["preview_name"] = "preview_mp_cargoship";
	level.iw4xmaps["wetwork"]["zone_name"] = "mp_cargoship";
}

monitorIntermission()//Standalone
{
	level waittill ( "spawning_intermission" );
	BeginVoteForMatch();
}

VoteTimerAndText(text, countDown)
{
	level notify("newVoteText");
	level endon("newVoteText");
	
	while(countDown)
	{
		foreach (player in level.players)
		{
			player setClientDvar( "hud_voteText",  (text+" (" + countDown + "s):"));
			player PlaySoundToPlayer( "ui_mp_timer_countdown", player );
		}
		wait 1;
		countDown--;
	}
}

BeginVoteForMatch()
{
	if(!isDefined(level.inVote))//Error in scripts/vote.gsc do not continue
		return;
	
	//Begin Vote
	level.inVote = true;
	level.VotePosition = "voting";
	
	updateVoteDisplayForPlayers();
	
	foreach(player in level.players)
		player thread StartVoteForPlayer();
	
	/*******Timer 1- Vote for new map*************************************/
	VoteTimerAndText("^3Vote for new map",level.VoteVoteTime);
	level notify( "time_over" );//End any further voting
	SetFinalVoteMap();//Set next map from votes / Randomised for no votes/players
	/*********************************************************************/
	
	/*******Timer 2- Show winner for new map*************************************/
	foreach (player in level.players)
		player setClientDvar( "hud_ShowWinner", "1" );
	level.VotePosition = "winner";
	VoteTimerAndText("^3Next Map", level.VoteWinnerTime);
	level.VotePosition = undefined;
	foreach (player in level.players)
	{
		player closeMenu( game["menu_vote"] );
		player setClientDvar( "ui_inVote", "0" );
		player setClientDvar( "hud_ShowWinner", "0" );
	}
	/*********************************************************************/
	
	foreach(player in level.players)
	{
		if(player.sessionstate != "intermission")
		player.sessionstate = "intermission";
	}
	
	//End Vote
	level.inVote = false;
}

StartVoteForPlayer()
{
	//Hide Intermission
	if(self.sessionstate != "spectator")
		self.sessionstate = "spectator";
	self freezeControlsWrapper( true );
	self closeMenus();
	self closepopupMenu();
	self closeInGameMenu();
	
	//Dvars
	self setClientDvar( "hud_ShowWinner", "0" );
	self setClientDvar( "ui_inVote", "1" );
	self openPopupMenu("vote");
	
	//Threads
	self thread onDisconnect();
}

getMapName( InputMap )
{
	map = tolower(InputMap);//Make lower case
	
	if(isDefined(level.iw4xmaps[map]))//In game map e.g "Terminal"
		return level.iw4xmaps[map]["zone_name"];
	else//Custom map e.g mp_waw_castle
		return map;
}

getPreviewName( InputMap )
{
	map = tolower(InputMap);//Make lower case
	
	if(isDefined(level.iw4xmaps[map]))//In game map e.g "Terminal"
		return level.iw4xmaps[map]["preview_name"];
	else//Custom map e.g mp_waw_castle
		return "preview_custom_map";
}

getLocalisedName( InputMap )
{
	map = tolower(InputMap);//Make lower case
	
	if(isDefined(level.iw4xmaps[map]))//In game map e.g "Terminal"
		return level.iw4xmaps[map]["localised_name"];
	else//Custom map e.g mp_waw_castle
		return map;
}

getGameTypeName( num )
{
	switch(level.gamemodeTok[num])
	{
		//MW2 Game Types
		case "dm":
			gamemode = "Free-for-all";
			break;
		case "war":
			gamemode = "Team Deathmatch";
			break;
		case "sd":
			gamemode = "Search and Destroy";
			break;
		case "sab":
			gamemode = "Sabotage";
			break;
		case "dom":
			gamemode = "Domination";
			break;
		case "koth":
			gamemode = "Headquarters";
			break;
		case "ctf":
			gamemode = "Capture the Flag";
			break;
		case "dd":
			gamemode = "Demolition";
			break;
		case "vip":
			gamemode = "VIP";
			break;
		case "gtnw":
			gamemode = "Global Thermonuclear War";
			break;
		case "oneflag":
			gamemode = "One Flag CTF";
			break;
		case "arena":
			gamemode = "Arena";
			break;
		//MW2:R Game Types
		case "gg":
			gamemode = "Gun Game";
			break;
		case "csgg":
			gamemode = "CS Gun Game";
			break;
		case "oitc":
			gamemode = "One in the Chamber";
			break;
		case "rgg":
			gamemode = "Reversed Gun Game";
			break;
		case "ultgg":
			gamemode = "Ultimative Gun Game";
			break;
		case "ss":
			gamemode = "Sharpshooter";
			break;
		default:
			gamemode = level.gamemodeTok[num];
	}
	
	return gamemode;
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onMenuResponse();
		player thread playerInitVote();
    }
}

playerInitVote()
{
	self setClientDvar( "ui_inVote", "0" );
	self setClientDvar( "ui_selected_vote", "" );
	
	//Joined late
	if(level.inVote && isDefined(level.VotePosition))
	{	
		if(level.VotePosition == "voting")
		{
			wait 1;
			updateVoteDisplayForPlayers();
			self StartVoteForPlayer();
		}
		else if(level.VotePosition == "winner")
		{
			wait 1;
			winNumberA = getHighestVotedMap();
			self StartVoteForPlayer();
			self setClientDvar( "hud_voteText", "^3Next Map:" );
			self setClientDvar( "hud_ShowWinner", "1" );
			self setClientDvar(("hud_WinningName"), getPreviewName(level.mapTok[winNumberA]));
			if(!isDefined(level.gamemodeTok))
				MapNameLoc = ("^3" + getLocalisedName(level.mapTok[winNumberA]));
			else
				MapNameLoc = ("^3" + getLocalisedName(level.mapTok[winNumberA]) + " - " + getGameTypeName(winNumberA));
			self setClientDvar(("hud_WinningMap"), MapNameLoc);
		}
	}
}

onMenuResponse()
{
    self endon("disconnect");

    for(;;)
    {
        self waittill("menuresponse", menu, response);
		
		if(menu==game["menu_vote"] && level.inVote)//Prevent Early Voting
        {
			switch(response)
			{
			case "map1":
				self castMap(0);
				break;
			case "map2":
				self castMap(1);
				break;
			case "map3":
				self castMap(2);
				break;
			case "map4":
				self castMap(3);
				break;
			case "map5":
				self castMap(4);
				break;
			case "map6":
				self castMap(5);
				break;
			case "map7":
				self castMap(6);
				break;
			case "map8":
				self castMap(7);
				break;
			case "map9":
				self castMap(8);
				break;
			default:
				break;
			}
        }
		if(response == "back" && level.inVote)//Re open vote menu after closing other menu
			self openPopupMenu("vote");
	}
}

restructMapArray(oldArray, index)
{
   restructArray = [];
	for( i=0; i < oldArray.size; i++) {
		if(i < index) 
			restructArray[i] = oldArray[i];
		else if(i > index) 
			restructArray[i - 1] = oldArray[i];
	}
	return restructArray;
}

updateVoteDisplayForPlayers()
{
	foreach(player in level.players)
	{
		player setClientDvar("hud_gamesize", level.players.size);
		for(i=0; i < level.mapTok.size; i++) 
		{
			player setClientDvar(("hud_picName"+i), getPreviewName(level.mapTok[i]));
			player setClientDvar(("hud_mapName"+i), getLocalisedName(level.mapTok[i]));
			
			if(!isDefined(level.gamemodeTok))
				GameTypeLocVotes = level.mapVotes[i];
			else
				GameTypeLocVotes = (getGameTypeName(i) + " - " + level.mapVotes[i]);
			player setClientDvar(("hud_mapVotes"+i), GameTypeLocVotes);
			
			if(level.mapVotes[i] != 0)
			{
				if(!isDefined(level.gamemodeTok))
					GameTypeLocVotes = ("^3"+level.mapVotes[getHighestVotedMap()]);
				else
					GameTypeLocVotes = ("^3" + getGameTypeName(getHighestVotedMap()) + " - " + level.mapVotes[getHighestVotedMap()]);
				player setClientDvar(("hud_mapVotes"+getHighestVotedMap()),GameTypeLocVotes );
				player setClientDvar(("hud_mapName"+getHighestVotedMap()), ("^3"+getLocalisedName(level.mapTok[getHighestVotedMap()])));
			}
		}
	}
}


getHighestVotedMap()
{
	highest = 0;

	position = randomInt(level.mapVotes.size);
	
	for(i=0; i < level.mapVotes.size; i++ ) 
	{
		if( level.mapVotes[i] > highest ) 
		{
			highest = level.mapVotes[i];
			position = i;
		}
	}		

	return position;
}

castMap( number )
{
	if( !isDefined(self.hasVoted) || !self.hasVoted ) {
		self.hasVoted = 1;
		level.mapVotes[number]++;
		self.votedNum = number;
		updateVoteDisplayForPlayers();
		if(!isDefined(level.gamemodeTok))
				MapNameLoc = getLocalisedName(level.mapTok[self.votedNum]);
			else
				MapNameLoc = (getLocalisedName(level.mapTok[self.votedNum]) + " - " + getGameTypeName(self.votedNum));
		self iprintln("You voted for ^3"+MapNameLoc);
	}
	else if( self.hasVoted && isDefined( self.votedNum ) && self.votedNum != number )
	{
		level.mapVotes[self.votedNum]--;
		level.mapVotes[number]++;
		self.votedNum = number;
		updateVoteDisplayForPlayers();
		if(!isDefined(level.gamemodeTok))
				MapNameLoc = getLocalisedName(level.mapTok[self.votedNum]);
			else
				MapNameLoc = (getLocalisedName(level.mapTok[self.votedNum]) + " - " + getGameTypeName(self.votedNum));
		self iprintln("You ^3re-voted ^7for ^3"+MapNameLoc);
	}
}

onDisconnect()
{
	level endon ( "time_over" );
	self waittill ( "disconnect" );
	
	if(level.inVote && isDefined(level.VotePosition))//Remove players vote & update player count for all
	{
		if ( isDefined( self.votedNum ) ) 
			level.mapVotes[self.votedNum]--;
		if (level.VotePosition == "voting")
			updateVoteDisplayForPlayers();
	}
}

SetFinalVoteMap()
{
	winNumberA = randomInt(level.mapTok.size);
	level.RandomMap = level.mapTok[winNumberA];  
	level.winMap = getMapName( level.RandomMap );

	if( level.players.size > 0 )
	{
		winNumberA = getHighestVotedMap();
		level.winMap = getMapName( level.mapTok[winNumberA] );
		foreach (player in level.players)
		{
			player setClientDvar(("hud_WinningName"), getPreviewName(level.mapTok[winNumberA]));
			if(!isDefined(level.gamemodeTok))
				MapNameLoc = ("^3" + getLocalisedName(level.mapTok[winNumberA]));
			else
				MapNameLoc = ("^3" + getLocalisedName(level.mapTok[winNumberA]) + " - " + getGameTypeName(winNumberA));
			player setClientDvar(("hud_WinningMap"), MapNameLoc);
			if(isDefined(level.gamemodeTok))
				player setClientDvar(("ui_gametype"), level.gamemodeTok[winNumberA]);
		}
	}
	
	//Only Map no game modes
	if(!isDefined(level.gamemodeTok))
	{
		setDvar("sv_maprotation", "map "+level.winMap);
		setDvar("sv_maprotationCurrent", "map "+level.winMap);
	}
	else//Set Game type and map
	{
		setDvar("sv_maprotation", "gametype " + level.gamemodeTok[winNumberA] + " map "+level.winMap);
		setDvar("sv_maprotationCurrent", "gametype " + level.gamemodeTok[winNumberA] + " map "+level.winMap);
	}
}