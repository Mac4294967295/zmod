        /* No one likes egotistical faggots. This bitch has GPL. */
		/* big thanks to chaz for the patch and his help.*/
		/* Edited by [UD]Funky */
		
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;


ArtilleryStrike()
{
	self endon("disconnect");
	
	
	//Coordinates Selection for the Location of the Artillery Strike
	self beginLocationSelection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
	self.selectingLocation = true;
	self waittill( "confirm_location", location, directionYaw );
	ArtilleryPointSelection = BulletTrace( location, ( location + ( 0, 0, -100000 ) ), 0, self )[ "position" ];
	
	self endLocationSelection();
	self.selectingLocation = undefined;
	
	self iPrintlnBold("Artillery Strike activated");
	
	wait 5;
	
	
	//Defining the Number of Total Artillery Strikes (24-32)
	AmountOfStrikes = randomInt(25) + 8;
	
	for (i = 1; i <= AmountOfStrikes; i++)
	{
		//Declaring x/y
		x = RandomIntRange(-40, 40) * 10;
		y = RandomIntRange(-40, 40) * 10;

		//Declaring the ArtilleryImpactPoint relative to the ArtilleryPointSelection
        ArtilleryImpactPoint = ArtilleryPointSelection+(x, y, 8000);
				
		//Random Number (1-10)
		rand_ammo = RandomInt(9) + 1;
		
		//Ammunition Selection
		// 8/10 Chance for 40mm, 2/10 for 105mm
		if(rand_ammo <= 8)
		{
			ArtilleryAmmo = "ac130_40mm_mp";
		}
		else
		{
			ArtilleryAmmo = "ac130_105mm_mp";			
		}
		
		//Spawns the Artillery Shot
        MagicBullet( ArtilleryAmmo, ArtilleryImpactPoint, ArtilleryImpactPoint-(0, 0, 8000), self );		
		
		//Interval in seconds
		wait RandomFloatRange(0.1, 0.8);	
	}
}


tryUseCustomAirstrike()
{
    self notifyOnPlayerCommand( "[{+actionslot 2}]", "+actionslot 2" );
	self endon ( "death" );
	self endon ( "disconnect" );
	
	
	self waittill ( "[{+actionslot 2}]" );
	
		self beginLocationSelection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
		self.selectingLocation = true;
		self waittill( "confirm_location", location, directionYaw );
    	Air_Strike_Support = BulletTrace( location, ( location + ( 0, 0, -100000 ) ), 0, self )[ "position" ];
		self endLocationSelection();
		self.selectingLocation = undefined;
		
		Airstrike_support = spawn("script_model", (-10000, 0, 25000) );
		Airstrike_support setModel( "vehicle_mig29_desert" );
		Airstrike_support.angles = (70, 0, 0);
		Airstrike_support playLoopSound( "veh_b2_dist_loop" );
		
		
		Airstrike_support moveTo( Air_Strike_Support + (0, 0, 3000), 5 );
		
		wait 4;
		MagicBullet( "javelin_mp", Airstrike_support.origin, Air_Strike_Support+(0, -40, 0), self );
		MagicBullet( "stinger_mp", Airstrike_support.origin, Air_Strike_Support+(0, 40, 0), self );
		wait 0.1;
		MagicBullet( "javelin_mp", Airstrike_support.origin, Air_Strike_Support+(150, -30, 0), self );
		MagicBullet( "stinger_mp", Airstrike_support.origin, Air_Strike_Support+(-150, 30, 0), self );
		wait 0.1;
		
		MagicBullet( "javelin_mp", Airstrike_support.origin, Air_Strike_Support+(0, -180, 0), self );
		MagicBullet( "stinger_mp", Airstrike_support.origin, Air_Strike_Support+(0, 180, 0), self );
		wait 0.1;
		MagicBullet( "javelin_mp", Airstrike_support.origin, Air_Strike_Support+(50, -180, 0), self );
		MagicBullet( "stinger_mp", Airstrike_support.origin, Air_Strike_Support+(-50, 180, 0), self );
		wait 0.1;
		
		MagicBullet( "ac130_105mm_mp", Airstrike_support.origin, Air_Strike_Support+(0, -10, 0), self );
		MagicBullet( "ac130_105mm_mp", Airstrike_support.origin, Air_Strike_Support+(0, 10, 0), self );
		wait 0.6;
    
		Airstrike_support.angles = (50, 0, 0);
		Airstrike_support moveTo( Airstrike_support.origin-(-50, 0, 50), 0.1 );
		wait 0.1;
		Airstrike_support.angles = (30, 0, 0);
		Airstrike_support moveTo( Airstrike_support.origin-(-50, 0, 50), 0.1 );
		wait 0.1;
		Airstrike_support.angles = (10, 0, 0);
		Airstrike_support moveTo( Airstrike_support.origin-(-50, 0, 50), 0.1 );
		wait 0.1;
		Airstrike_support.angles = (0, 0, 0);
		
		Airstrike_support moveTo( Airstrike_support.origin+(10000, 0, 0), 3 );
		
		
		wait 3;
		
		Airstrike_support stoploopsound( "veh_b2_dist_loop" );
		Airstrike_support delete();
		Air_Strike_Support = undefined;
}


Ammo( amnt )
{
self endon("disconnect");
self endon("death");
self endon("noboom");
self endon("reload");
 
		while ( 1 ) {
		currentweapon = self GetCurrentWeapon();
			self setWeaponAmmoClip( currentweapon, amnt );
			self setWeaponAmmoClip( currentweapon, amnt, "left" );
			self setWeaponAmmoClip( currentweapon, amnt, "right" );
		wait 0.05; }
}

GrimReaper()
{
    self endon("death");
    self endon("noboom");

    self.specialactive = 1;
    self thread Autoswitch();
    self thread RemoveGrim();
    self thread Ammo(9);
    self giveWeapon("at4_mp", 0, true);
    self switchToWeapon("at4_mp");
    for(;;){
    self waittill ("weapon_fired");
    forward = self getTagOrigin("tag_weapon_left");
    end = self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
    location = BulletTrace( forward, end, 0, self )[ "position" ];
    MagicBullet( "ac130_105mm_mp", forward, location, self );}
}

Autoswitch()
{
    self endon("death");
    self endon("noboom");

    for(;;){
    self switchToWeapon("at4_mp");
    wait 0.1;}
}

RemoveGrim()
{
    self endon("death");

    old = self getCurrentWeapon();
    self.rockets = 8;
    Rockets = self createFontString( "default", 2.5 );
    Rockets setPoint( "LEFT", "LEFT", 0, 150);
    Rockets setValue(self.rockets);
    for(;;)
    {
    self waittill ("weapon_fired");
    self.rockets -= 1;
    Rockets setValue(self.rockets);
    if(self.rockets == 4)
    {
    self thread Ammo(0);
    self notify("reload");
    self setWeaponAmmoStock("at4_mp", 3);	
    self waittill ("weapon_fired");
    self thread Ammo(9);
    }
    if(self.rockets == 0)
    {
    Rockets destroy();
    self notify("noboom");
    self thread Ammo(0);
    self SwitchToWeapon(old);	
    wait 0.2;
    self takeWeapon("at4_mp");
    }
    }
}

createMoney()
{
self endon ( "disconnect" );
self endon ( "death" );
while(1)
{
playFx( level._effect["money"], self getTagOrigin( "j_spine4" ) );
wait 0.5;
}
}

doFX()
{
if(self.pers["team"] == "axis")
{
playFxOnTag( level.spawnGlow["enemy"], self, "pelvis" ); //red
}
if(self.pers["team"] == "allies")
{
playFxOnTag( level.spawnGlow["friendly"], self, "j_head" ); //green
}
}
setup_dvar(dname, dval)
{
	if (getDvar(dname) == "")
		setDvar(dname, dval);
}

doRoundWaitEnd()
{
	level waittill("game_ended");
	foreach (player in level.players)
	{
		player.kills = player.savedStat["kills"];
		player.assists = player.savedStat["assists"];
		player.deaths = player.savedStat["deaths"];
		player.score = player.savedStat["score"];
	}
}

chaz_init()
{
	level thread doRoundWaitEnd();
	level.debug = 0;
	setup_dvar("scr_zmod_debug", "0");
	if (getDvarInt("scr_zmod_debug") != 0)
		level.debug = 1;
		
	setup_dvar("scr_zmod_round_gap", "5");
	
	if (level.debug)
		level.enablekillcam = false;
	else
		level.enablekillcam = true;
	setup_dvar("scr_zmod_alpha_count", "0");
	setup_dvar("scr_zmod_autoadjust", "1");
	setup_dvar("scr_zmod_survival", "1");
	setup_dvar("scr_zmod_randomize_init", "1");
	setup_dvar("scr_zmod_skip_debugger", "0");
	setup_dvar("scr_zmod_max_lives", "4");
	setup_dvar("scr_zmod_rofl_ammo", "200");
	setup_dvar("scr_zmod_semtex_ammo", "5");
	setup_dvar("scr_zmod_frag_ammo", "5");
	setup_dvar("scr_zmod_claymore_ammo", "5");
	setup_dvar("scr_zmod_c4_ammo", "5");
	setup_dvar("scr_zmod_repair_points", "15");
	setup_dvar("scr_zmod_intermission_time", "50");
	setup_dvar("scr_zmod_starting_time", "60");
	setup_dvar("scr_zmod_alpha_time", "10");
	setup_dvar("scr_zmod_mapwait_time", "25");
	setup_dvar("scr_zmod_nuke_time", "25");
	setup_dvar("scr_zmod_trade_distance", "80");
	setup_dvar("scr_zmod_trade_timeout", "12");
	setup_dvar("scr_zmod_tradeSearch_timeout", "5");
	setup_dvar("scr_zmod_darken", "1");
	setup_dvar("scr_zmod_sentry_timeout", "200");
	setup_dvar("scr_zmod_inf_knives", "10");
	setup_dvar("scr_zmod_inf_ammo", "30");
	setup_dvar("scr_zmod_human_challenge", "1");
	setup_dvar("scr_zmod_zombie_challenge", "1");
	setup_dvar("scr_zmod_disable_weapondrop", "1");
	setup_dvar("scr_zmod_infotext", "^2Cycle Menu: ^3[{+actionslot 3}]^7/^3[{+actionslot 1}]");
	explosivemax = getDvarInt("scr_maxPerPlayerExplosives");
	equipmentmax = [];
	equipmentmax[0] = getDvarInt("scr_zmod_frag_ammo");
	equipmentmax[1] = getDvarInt("scr_zmod_semtex_ammo");
	equipmentmax[2] = getDvarInt("scr_zmod_claymore_ammo");
	equipmentmax[3] = getDvarInt("scr_zmod_c4_ammo");
	for (i = 0; i < equipmentmax.size; i++)
		if (equipmentmax[i] > explosivemax)
			explosivemax = equipmentmax[i];
	if (getDvarInt("scr_maxPerPlayerExplosives") != explosivemax)
		setDvar("scr_maxPerPlayerExplosives", explosivemax);
	
	level.round_type = "";
	level.round_type_next = "";
	level.cround = 0;
	level.rounds = [];
	level.rounds[0] = "survival";
	level.rounds[1] = "megaboss";
	
	level.rounds_dvar[0] = "scr_zmod_survival";
	level.rounds_dvar[1] = "scr_zmod_megaboss";
	
	level.round_msg = [];
	level.round_msg[0] = "^3Get ready for ^2SURVIVAL^3 Round!";
	
	level.nadetypes = [];
	level.nadetypes[0] = "frag_grenade_mp";
	level.nadetypes[1] = "semtex_mp";
	level.nadetypes[2] = "claymore_mp";
	level.nadetypes[3] = "c4_mp";
	level.nadenames = [];
	level.nadenames[0] = "Frag";
	level.nadenames[1] = "Semtex";
	level.nadenames[2] = "Claymore";
	level.nadenames[3] = "C4 Charge";
	
	clearChallenges();
	level.hchallenge_reward = ::humanChallengeReward;
	level.zchallenge_reward = ::zombieChallengeReward;

	level.icon_trade = "waypoint_targetneutral";
	precacheShader ( level.icon_trade );	
}

TS_IDLE = 0;//Normal mode
TS_OFFERING = 1;//Looking for someone
TS_CONFIRM = 2;//Confirming

getTeam(team)
{
	p = [];
	i = 0;
	foreach (player in level.players)
		if (player.team == team)
			p[p.size] = player;
	return p;
}

getRealWeaponName(weap)
{
	parts = strtok(weap, "_");
	if (!parts || !parts.size)
		return "[ERROR]";
	weap = level.weapname[parts[0]];
	if (isDefined(weap))
		return weap;
	return "[ERROR unknown weap: " + weap + "]";
}

getRandomWeapon(class, which)
{
	weap = "";
	sz = getWeaponSize(class);
	if (sz == 0)
		return "[ERROR - no class " + class + " exists]";
	if (!isDefined(which))
		which = randomInt(getWeaponSize(class));
	switch(class)
	{
		case "weapon_lmg":
			weap = level.lmg[which];
			break;
		case "weapon_assault":
			weap = level.assault[which];
			break;
		case "weapon_smg":
			weap = level.smg[which];
			break;
		case "weapon_shotgun":
			weap = level.shot[which];
			break;
		case "weapon_machine_pistol":
			weap = level.machine[which];
			break;
		case "weapon_pistol":
			weap = level.hand[which];
			break;
		case "weapon_sniper":
			weap = level.rifle[which];
			break;
		case "weapon_riot":
			weap = "riotshield";
			break;
		case "weapon_explosives":
			weap = level.explosives[which];
			break;
		default:
			weap = "";
			break;
	}
	if (!isDefined(weap))
		return "[Undefined weapon i:" + which + " class:" + class + " sz: " + sz + "]";
	if (weap == "")
		return "[unnkown class: " + class + "]";
	return weap + "_mp";
}

getWeaponSize(class)
{
	weap = 0;
	switch(class)
	{
		case "weapon_lmg":
			weap = level.lmg.size;
			break;
		case "weapon_assault":
			weap = level.assault.size;
			break;
		case "weapon_smg":
			weap = level.smg.size;
			break;
		case "weapon_shotgun":
			weap = level.shot.size;
			break;
		case "weapon_machine_pistol":
			weap = level.machine.size;
			break;
		case "weapon_pistol":
			weap = level.hand.size;
			break;
		case "weapon_sniper":
			weap = level.rifle.size;
			break;
		case "weapon_riot":
			weap = 1;
			break;
		case "weapon_explosives":
			weap = level.explosives.size;
			break;
		default:
			weap = 0;
			break;
	}
	return weap;
}

generateHumanChallengeNormal()
{
	zombies = getTeam("axis");

	who = zombies[randomInt(zombies.size)];
	weap = getRandomWeapon(level.weaponclasses[randomInt(level.weaponclasses.size)]);
	kills = 1 + randomInt(6);
	level.hchallenge_target = who.guid;
	level.hchallenge_weapon = strtok(weap, "_")[0];
	level.hchallenge_kills = kills;
	level.hchallenge_progress = kills;
	level thread ibroadcastDelay(0.1, "^3HUMAN CHALLENGE: ^1KILL ^7" + who.name + "^3 WITH ^7" + getRealWeaponName(weap) + " ^3" + kills + " TIMES!", "allies");
}

generateZombieChallengeNormal()
{
	humans = getTeam("allies");
	zombies = getTeam("axis");

	who = humans[randomInt(humans.size)];
	assailant = zombies[randomInt(zombies.size)];
	level.zchallenge_target = who.guid;
	level.zchallenge_ass = assailant.guid;
	level.zchallenge_progress = 1;
	level thread ibroadcastDelay(0.1, "^3ZOMBIE CHALLENGE: ^7" + assailant.name + "^3 MUST KILL ^7" + who.name, "axis");
}

processChallengeKill(killer, victim, weap)
{
	weapon = strtok(weap, "_")[0];
	if (killer.team == "axis")
	{
		if (level.zchallenge_progress == 0) {
			return;
		}
		if (victim.team != "allies"){
			level.zchallenge_progress = 0;
			return;
		}
		if (victim.guid != level.zchallenge_target){
			return;
		}
		if (killer.guid != level.zchallenge_ass) {
			level.zchallenge_progress = 0;
			return;
		}
		level.zchallenge_progress = 0;
		level thread playSoundOnPlayers("mp_enemy_obj_taken", "axis");
		level thread playSoundOnPlayers("mp_defcon_down", "allies");
		
		thread doPlaceMsgText("^3Zombie Challenge Complete!", "^1" + killer.name + "^3 has given zombies infinite knives for ^5"+ getDvarInt("scr_zmod_inf_knives") +"^3 secs!", 7);
		thread [[level.zchallenge_reward]]();
	}
	else
		if (killer.team == "allies")
		{
			level.hchallenge_progress--;
			if (level.hchallenge_progress == 0) {
				level thread playSoundOnPlayers("mp_enemy_obj_taken", "allies");
				level thread playSoundOnPlayers("mp_defcon_down", "axis");
				thread doPlaceMsgText("^3Human Challenge Complete!", "^1" + killer.name + "^3 has given humans infinite ammo for ^5" + getDvarInt("scr_zmod_inf_ammo") + "^3 secs!", 7);
				thread [[level.hchallenge_reward]]();
			}
			else{
				thread doPlaceMsgText(undefined, "^7Human Challenge Progress: ^3" + floor((1 - (level.hchallenge_progress / level.hchallenge_kills))*100) + " ^7PERCENT", 3);
			}
		}
}

challengeTimeoutNotify(msg, time, dmsg)
{
	level endon("game_ended");
	level endon("gamestatechange");
	wait time;
	level notify(msg);
	ibroadcast(dmsg);
}

humanChallengeReward()
{
	level endon("game_ended");
	level endon("gamestatechange");
	level endon("infammotimeout");
	time = getDvarInt("scr_zmod_inf_ammo");
	thread challengeTimeoutNotify("infammotimeout", time, "INFINITE AMMO FOR HUMANS ^1ENDED!");
	for (;;)
	{
		foreach (player in level.players){
			if (player.team != "allies")
				continue;
			weap = player getCurrentWeapon();
			if (weap == "" || weap == "defaultweapon_mp")
				continue;
			player setWeaponAmmoClip(weap, weaponClipSize(weap));
		}
		wait 0.35;
	}
}

zombieChallengeReward()
{
	level endon("game_ended");
	level endon("gamestatechange");
	level endon("infknivestimeout");
	time = getDvarInt("scr_zmod_inf_ammo");
	thread challengeTimeoutNotify("infknivestimeout", time, "INFINITE KNIVES FOR ZOMBIES ^1ENDED!");
	for (;;)
	{
		foreach (player in level.players){
			if (player.team != "axis")
				continue;
			if (!player hasWeapon("throwingknife_mp")){
				player maps\mp\perks\_perks::givePerk( "throwingknife_mp" );
				player setWeaponAmmoClip("throwingknife_mp", 1);
			}
			if (player getWeaponAmmoClip("throwingknife_mp") == 0)
				player setWeaponAmmoClip("throwingknife_mp", 1);
		}
		wait 0.35;
	}
}


clearChallenges()
{
	level.hchallenge_target = 0;
	level.hchallenge_weapon = "";
	level.hchallenge_kills = 0;
	level.hchallenge_progress = 0;
	
	level.zchallenge_target = 0;
	level.zchallenge_ass = 0;
	level.zchallenge_progress = 0;
}

doChallenges()
{
	level endon("game_ended");
	for (;;)
	{
		level waittill("gamestatechange");
		if (level.gameState != "playing")
			continue;
		if (level.round_type != "")
			continue; 
		wait 1.2;
		clearChallenges();
		if (getDvarInt("scr_zmod_human_challenge") != 0)
			generateHumanChallengeNormal();
		if (getDvarInt("scr_zmod_zombie_challenge") != 0)
			generateZombieChallengeNormal();
	}
}

assistedKill(who)
{
	if (level.gameState != "playing" || who.team == self.team)
		return;
	earn = 0;
	if (self.team == "allies")
		earn = 25;
	else
		if (self.team == "axis")
			earn = 50;
	self justScorePopup("Assist: +$" + earn);
	self statCashAdd(earn);
}

killedPlayer(who, weap)
{
	if (self.team == who.team || level.gameState != "playing")
		return;
	if (self.team == who.team)
		return;
	processChallengeKill(self, who, weap);
	
	
	//Testing money on Player Killed, +5000 | Testversion
	self statCashAdd(5000);
	
	
	if (self.isZombie != 0)
	{
		amount = 100 + (50 * self.combo);
		
		self statCashAdd(amount);
		self.combo++;
		if (self.combo > 1)
			self thread justScorePopup("Kill Combo! x" + self.combo + " +$" + amount);
		else
			self thread justScorePopup("Killed Human! +$" + amount);
		self notify("CASH");
	}
	else
	{
		who statCashAdd(50);
		who justScorePopup("Died! +$50");
		
		earn = 50;
		if (weap == "melee_mp")
		{
			earn *= 4;
			self thread justScorePopup("Melee Kill! +$" + earn);
		}
		else
			self thread justScorePopup("Killed Zombie! +$" + earn);
		self statCashAdd(earn);
	}
}

init_player_extra()
{
		self.isRepairing = false;
		self.rp = 0;
		self.lives = 0;
		self.credit_kills = 0;
		self.humancash = false;
		self.zombiecash = false;
		self.fullammo = false;
		self.antialpha = false;
		self.atk = 1;
		self.cheapnuke = false;
		self.commandopro = false;
		self.hasROFL = false;
		self.nadetype = 0;
		self.eotech = false;
		self.ack["used_life"] = false;
		self.ack["safe"] = false;
		self.ack["ts"] = TS_IDLE;
		self.offerfirst = false;
		self.humanfs = false;
		self.riotz = false;
		self.tact = false;
		self.blastshield = false;
		self.combo = 0;
		self.savedStat["kills"] = 0;
		self.savedStat["assists"] = 0;
		self.savedStat["deaths"] = 0;
		self.savedStat["score"] = 0;
}

isValidWeaponForTrade(weap)
{
		switch(getWeaponClass(weap))
		{
			case "weapon_lmg":
			case "weapon_assault":
			case "weapon_smg":
			case "weapon_shotgun":
			case "weapon_machine_pistol":
			case "weapon_pistol":
			case "weapon_sniper":
			case "weapon_riot":
				return true;
			default:
				return false;
		}
		return false;
}

dropDead()
{
	foreach (player in level.players)
		player suicide();
}

saveus()
{
	w = self getNadeWeap();
		e = "[not have]";
		if (self hasWeapon(w))
			e = "";
		self iprintlnbold(w + e + " clip: " + self getWeaponAmmoClip(w) + " stock: " + self getWeaponAmmoStock(w));
}

coords_thread()
{
	self endon("disconnect");
	level.ooo = "1";
	cur = 0;
	curc = 7;
	sz = 0;
	while(1)
	{
		self waittill("daction_coords");
		doPlaceMsgText("^2What the Shit?", "^6Zombies are now GROOVY! ", 3);
		level playSoundOnPlayers("mp_defcon_down");
	}
}

CleanupKillstreaks()
{
	//reset and player sentry states
	foreach (player in level.players)
			player notify("cancel_sentry");
	//delete sentries
	level deletePlacedEntity("misc_turret"); //Deletes mounted ones setup on the map too
	//delete heli's
	helis = level.helis;
	foreach (heli in helis)
	{
		heli notify("death");
		heli delete();
	}
	//remove ac130
	if (isDefined(level.ac130player))
	{
		level thread maps\mp\killstreaks\_ac130::removeAC130Player( level.ac130player, false);
	}
}

first_round_init()
{
	if (!getDvarInt("scr_zmod_randomize_init"))
		return;
	c = randomInt(level.players.size);
	for(i = 0; i < c; i++)
		level.players[i].wasAlpha = 1;
	c = randomInt(level.players.size);
	for(i = 0; i < c; i++)
		level.players[i].wasSurvivor = 1;
}

setCreditsPersistent()
{
	self SetPlayerData("zmod_credits", self.credits);
}

getCreditsPersistent()
{
	cred = self GetPlayerData("zmod_credits");
	if (!cred)
		return 0;
	return cred;
}

doSetup(isRespawn)
{
	if (self.team == "axis" || self.team == "spectator")
	{
		self notify("menuresponse", game["menu_team"], "allies");
		wait .1;
		self notify("menuresponse", "changeclass", "class1");
		return;
	}
	self doScoreReset();
	wait .1;
	self notify("menuresponse", "changeclass", "class1");
	self takeAllWeapons();
	if (level.gameState == "playing" && isRespawn)
		self giveNonIntermissionPermissableItem();
	self _clearPerks();
	self.blastshield = false;
	self ThermalVisionFOFOverlayOff();
	self.randomlmg = randomInt(level.lmg.size);
	self.randomar = randomInt(level.assault.size);
	self.randommp = randomInt(level.machine.size);
	self.randomsmg = randomInt(level.smg.size);
	self.randomsr = randomInt(level.rifle.size);
	self.randomshot = randomInt(level.shot.size);
	self.randomhand = randomInt(level.hand.size);

	
	if (self.cheapnuke == true)
		self.nuke_price = level.itemCost["nuke_cheap"];
	else
		self.nuke_price = level.itemCost["nuke"];

	self giveWeapon(level.smg[self.randomsmg] + "_mp", 0, false);
	self giveWeapon(level.shot[self.randomshot] + "_mp", 0, false);
	self giveWeapon(level.hand[self.randomhand] + "_mp", 0, false);
	self GiveMaxAmmo(level.smg[self.randomsmg] + "_mp");
	self GiveMaxAmmo(level.shot[self.randomshot] + "_mp");
	self GiveMaxAmmo(level.hand[self.randomhand] + "_mp");
	self switchToWeapon(level.smg[self.randomsmg] + "_mp");
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
	self maps\mp\perks\_perks::givePerk("specialty_quieter");
	self thread doHW();
	self.isZombie = 0;
	self.isRepairing = false;
	self.rp = 0;
	self.bounty = 0;
	if (self.humancash == true)
		self.bounty = 200;
	else
		if (self.ack["used_life"] == true)
			self.ack["used_life"] = false;
		else
			self.bounty = 0;
	if (level.debug != 0)
		self.bounty = 10000;
	
	self.attach1 = [];
	self.attachweapon = [];
	self.attachweapon[0] = 0;
	self.attachweapon[1] = 0;
	self.attachweapon[2] = 0;
	self.attach1[0] = "none";
	self.attach1[1] = "none";
	self.attach1[2] = "none";
	self.currentweapon = 0;
	self thread doPerksSetup();
	self thread doPerkCheck();
	self thread monitorRepair();
	self.maxhp = 100;
	self.maxhealth = self.maxhp;
	self.health = self.maxhealth;
	self.moveSpeedScaler = 1;
	if (level.debug == 0)
		self.thermal = 0;
	else
		self.thermal = 1;
	
	if(self.thermal == 1)
	{
		self ThermalVisionFOFOverlayOn();
	}
	
	self.throwingknife = 0;
	self.stinger = 0;
	if (level.ShowCreditShop == true)
		self.creditshop = true;
	else
		self.creditshop = false;
	self setClientDvar("g_knockback", 1000);

	notifySpawn = spawnstruct();
	notifySpawn.titleText = "Human";
	notifySpawn.notifyText = "Survive for as long as possible!";
	notifySpawn.glowColor = (0.0, 0.0, 1.0);
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifySpawn );
	self thread doHumanShop();
	
	self.menu = 0;
	self notify("CASH");
	self notify("HEALTH");
	self notify("LIVES");
	self notify("MENUCHANGE");
	self notify("SETUPDONE");
}


doAlphaZombie()
{
	if(self.team == "allies")
	{
		self notify("menuresponse", game["menu_team"], "axis");
		self doScoreReset();
		self setWeaponAmmoClip("throwingknife_mp", 0);
		self ThermalVisionFOFOverlayOff();
		self.throwingknife = 0;
		self.stinger = 0;
		self.bounty = 0;
		if (self.zombiecash == true)
			self.bounty = 200;
		else
			self.bounty = 50;
		self.ck = self.kills;
		self.cd = self.deaths;
		self.cs = self.suicides;
		self.maxhp = 200;
		self thread doPerksSetup();
		wait .1;
		self notify("menuresponse", "changeclass", "class3");
		self notify("CASH");
		self notify("HEALTH");
		self notify("LIVES");
		self notify("MENUCHANGE");
		return;
	}
	wait .1;
	self notify("menuresponse", "changeclass", "class3");
	self takeAllWeapons();
	self _clearPerks();
	self giveWeapon("usp_tactical_mp", 0, false);
	self thread doZW();
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	self maps\mp\perks\_perks::givePerk("specialty_thermal");
	if(self.thermal == 1)
	{
		self ThermalVisionFOFOverlayOn();
	}
	
	self givePossesions();
	
	self thread doPerkCheck();
	self.maxhealth = self.maxhp;
	self.health = self.maxhealth;
	self.moveSpeedScaler = 1.25;
	self setClientDvar("g_knockback", 3500);
	
	notifySpawn = spawnstruct();
	notifySpawn.titleText = "^0Alpha Zombie";
	notifySpawn.notifyText = "Nom nom for ^3brains!";
	notifySpawn.glowColor = (1.0, 0.0, 0.0);
	
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifySpawn );
	self thread doZombieShop();
	self notify("CASH");
	self notify("HEALTH");
	self notify("LIVES");
}

doZombie()
{
	if(self.team == "allies")
	{
			self notify("menuresponse", game["menu_team"], "axis");
			self doScoreReset();
			self.bounty = 50;
			if (level.debug != 0)
				self.bounty = 10000;
			if (level.debug == 0)
				self.thermal = 0;
			else
				self.thermal = 1;
			self.throwingknife = 0;
			self.stinger = 0;
			self setWeaponAmmoClip("throwingknife_mp", 0);
			self ThermalVisionFOFOverlayOff();
			
			self.ck = self.kills;
			self.cd = self.deaths;
			self.cs = self.suicides;
			self.maxhp = 150;
			self thread doPerksSetup();
			wait .1;
			self notify("menuresponse", "changeclass", "class3");
			return;
	}
	wait .1;
	self notify("menuresponse", "changeclass", "class3");
	self takeAllWeapons();
	self _clearPerks();
	self giveWeapon("usp_tactical_mp", 0, false);
	self thread doZW();
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	self maps\mp\perks\_perks::givePerk("specialty_thermal");
	if(self.thermal == 1)
	{
		self ThermalVisionFOFOverlayOn();
	}
	self givePossesions();
	self thread doPerkCheck();
			
	self.maxhealth = self.maxhp;
	self.health = self.maxhealth;
	self.moveSpeedScaler = 1.15;
	self setClientDvar("g_knockback", 3500);
	
	notifySpawn = spawnstruct();
	notifySpawn.titleText = "^0Zombie";
	notifySpawn.notifyText = "Welcome! You are hungry for ^2brains!";
	notifySpawn.glowColor = (1.0, 0.0, 0.0);
	
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifySpawn );
	self thread doZombieShop();
	self notify("CASH");
	self notify("HEALTH");
	self notify("LIVES");
}

/*Death machine script, copied from pastebin. Whoever made it, thanks for making my life easier*/
roflloop()
{
    self endon("disconnect");
    self endon("death");
    self.lastweap = self getCurrentWeapon();
     ammo = getDvarInt("scr_zmod_rofl_ammo");
        while(1)
        {
            if(self AttackButtonPressed() && self getCurrentWeapon() == "stinger_mp")
            {
	            tagorigin = self getTagOrigin("j_shouldertwist_le");  
	            firing = GetCursorPos();
	            x = randomIntRange(-10, 10);
	            y = randomIntRange(-10, 10);
	            z = randomIntRange(-10, 10);
	            MagicBullet( "rpg_mp", tagorigin, firing+(x, y, z), self );
	            ammo--;
            }
           if (ammo <= 0)
           	break;
        wait 0.1;
        }
    self takeWeapon(self getCurrentWeapon());
    self takeWeapon("stinger_mp");
    wait 0.2;
    self switchToWeapon(self.lastweap);
}
 
GetCursorPos()
{
        forward = self getTagOrigin("tag_eye");
        end = self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
        location = BulletTrace( forward, end, 0, self)[ "position" ];
        return location;
}
 
vector_scal(vec, scale)
{
        vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
        return vec;
}

doLastAlive()
{
	self endon("disconnect");
	self endon("death");
	wait 2;
	self setMoveSpeedScale(1.7);
	self GiveMaxAmmo(self.current);
	if (self.commandopro == true)
	{
			self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
			self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	}
	self thread maps\mp\gametypes\_quickmessages::quickstatements("7");
	self iPrintlnBold("^2You are ^1LAST-ALIVE! ^5SPEED BOOST ^2AND ^5FULL AMMO!");
	for(;;)
	{
		self _unsetPerk("specialty_coldblooded");
		self _unsetPerk("specialty_spygame");
		self.perkz["coldblooded"] = 3;
		wait .4;
	}
}


destroyTrace()
{
	if (isDefined(level.bosspoint))
	{
		level.bosspoint destroy();
		level.bosspoint = undefined;
	}
}


givePossesions()
{
	if(self.throwingknife == 1)
	{
		self thread monitorThrowingKnife();
		self maps\mp\perks\_perks::givePerk( "throwingknife_mp" );
		self setWeaponAmmoClip("throwingknife_mp", 1);
	}
	if (self.stinger > 0)
	{
		self giveWeapon("stinger_mp", 0, false);
		self setWeaponAmmoClip("stinger_mp", 1);
		if (self.stinger > 1)
			self setWeaponAmmoStock("stinger_mp", 1);
		else
			self setWeaponAmmoStock("stinger_mp", 0);
		self thread monitorStinger();
	}
}



monitorStinger()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		self.stinger = self getWeaponAmmoClip("stinger_mp") + self getWeaponAmmoStock("stinger_mp");
		wait 0.8;
	}
}


doZW()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	currentweap = undefined;
	while(1)
	{
		currentweap = self getCurrentWeapon();
		if (currentweap == "usp_tactical_mp" || currentweap == "stinger_mp" || currentweap == "riotshield_mp")
			{
				self setWeaponAmmoClip("usp_tactical_mp", 0);
				self setWeaponAmmoStock("usp_tactical_mp", 0);
			}
			else
				{
					self takeWeapon(currentweap);
					self switchToWeapon("usp_tactical_mp");
				}
		wait .5;
	}
}

doHW()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	while(1)
	{
		self.current = self getCurrentWeapon();
		switch(getWeaponClass(self.current))
		{
			case "weapon_lmg":
				self.exTo = "Unavailable";
				self.currentweapon = 0;
				break;
			case "weapon_assault":
				self.exTo = "LMG";
				self.currentweapon = 0;
				break;
			case "weapon_smg":
				self.exTo = "Assault Rifle";
				self.currentweapon = 0;
				break;
			case "weapon_shotgun":
				self.exTo = "Unavailable";
				self.currentweapon = 1;
				break;
			case "weapon_machine_pistol":
				self.exTo = "Unavailable";
				self.currentweapon = 2;
				break;
			case "weapon_pistol":
				self.exTo = "Machine Pistol";
				self.currentweapon = 2;
				break;
			case "weapon_sniper":
				self.exTo = "smg";
				self.currentweapon = 0;
				break;
			default:
				self.exTo = "Unavailable";
				self.currentweapon = 3;
				break;
		}
		
		basename = strtok(self.current, "_");
		
		if(basename.size > 2)
		{
				self.attach1[self.currentweapon] = basename[1];
				self.attachweapon[self.currentweapon] = basename.size - 2;
		}
		else
			{
					self.attach1[self.currentweapon] = "none";
					self.attachweapon[self.currentweapon] = 0;
			}
		
		if (self.currentweapon == 3 || self.attachweapon[self.currentweapon] == 2)
		{
			self.attach["akimbo"] = 0;
			self.attach["fmj"] = 0;
			self.attach["eotech"] = 0;
			self.attach["silencer"] = 0;
			self.attach["xmags"] = 0;
			self.attach["rof"] = 0;
			self.attach["reddot"] = 0;
			self.attach["acog"] = 0;
		}
		
		if((self.attachweapon[self.currentweapon] == 0) || (self.attachweapon[self.currentweapon] == 1))
		{
			akimbo = buildWeaponName(basename[0], self.attach1[self.currentweapon], "akimbo");
			fmj = buildWeaponName(basename[0], self.attach1[self.currentweapon], "fmj");
			eotech = buildWeaponName(basename[0], self.attach1[self.currentweapon], "eotech");
			silencer = buildWeaponName(basename[0], self.attach1[self.currentweapon], "silencer");
			xmags = buildWeaponName(basename[0], self.attach1[self.currentweapon], "xmags");
			rof = buildWeaponName(basename[0], self.attach1[self.currentweapon], "rof");
			acog = buildWeaponName(basename[0], self.attach1[self.currentweapon], "acog");
			reddot = buildWeaponName(basename[0], self.attach1[self.currentweapon], "reflex");
			
			
			if(isValidWeapon(akimbo))
				self.attach["akimbo"] = 1;
			else
				self.attach["akimbo"] = 0;
			if(isValidWeapon(fmj))
				self.attach["fmj"] = 1;
			else
					self.attach["fmj"] = 0;
			if(isValidWeapon(eotech))
					self.attach["eotech"] = 1;
			else
					self.attach["eotech"] = 0;
			if(isValidWeapon(silencer))
				self.attach["silencer"] = 1;
			else
				self.attach["silencer"] = 0;
			if(isValidWeapon(xmags))
				self.attach["xmags"] = 1;
			else
				self.attach["xmags"] = 0;
			if(isValidWeapon(rof))
				self.attach["rof"] = 1;
			else
				self.attach["rof"] = 0;
			if(isValidWeapon(acog))
				self.attach["acog"] = 1;
			else
				self.attach["acog"] = 0;
			if(isValidWeapon(reddot))
				self.attach["reddot"] = 1;
			else
				self.attach["reddot"] = 0;
		}
		wait .5;
	}
}

doPerkCheck()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	while(1)
	{
					
		if(self.perkz["steadyaim"] == 1)
		{
			if(!self _hasPerk("specialty_bulletaccuracy"))
					self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
		}
		
		if(self.perkz["steadyaim"] == 2)
		{
			if(!self _hasPerk("specialty_bulletaccuracy"))
				self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
			if(!self _hasPerk("specialty_holdbreath"))
				self maps\mp\perks\_perks::givePerk("specialty_holdbreath");
		}
		
		if(self.perkz["sleightofhand"] == 1)
		{
			if(!self _hasPerk("specialty_fastreload")) {
				self maps\mp\perks\_perks::givePerk("specialty_fastreload"); 
				self maps\mp\perks\_perks::givePerk("specialty_quickdraw");
			}
		}
		
		if(self.perkz["sleightofhand"] == 2)
		{
			if(!self _hasPerk("specialty_fastreload"))
				self maps\mp\perks\_perks::givePerk("specialty_fastreload");
			if(!self _hasPerk("specialty_fastsnipe"))
				self maps\mp\perks\_perks::givePerk("specialty_fastsnipe");
		}
		
		if(self.perkz["stoppingpower"] == 1)
		{
			if(!self _hasPerk("specialty_bulletdamage"))
				self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
		}
		
		
		if(self.perkz["stoppingpower"] == 2)
		{
			if(!self _hasPerk("specialty_bulletdamage"))
				self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
			if(!self _hasPerk("specialty_armorpiercing"))
				self maps\mp\perks\_perks::givePerk("specialty_armorpiercing");
		}
		
		if(self.perkz["coldblooded"] == 1)
		{
				if(!self _hasPerk("specialty_coldblooded"))
					self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
		}
		
		if(self.perkz["coldblooded"] == 2)
		{
			if(!self _hasPerk("specialty_coldblooded"))
				self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
			if(!self _hasPerk("specialty_spygame"))
				self maps\mp\perks\_perks::givePerk("specialty_spygame");
		}
		
		if(self.perkz["ninja"] == 1)
		{
			if(!self _hasPerk("specialty_heartbreaker"))
				self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
		}
		
		if(self.perkz["ninja"] == 2)
		{
			if(!self _hasPerk("specialty_heartbreaker"))
				self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
			if(!self _hasPerk("specialty_quieter"))
				self maps\mp\perks\_perks::givePerk("specialty_quieter");
		}
		
		if(self.perkz["lightweight"] == 1)
		{
			if(!self _hasPerk("specialty_lightweight"))
				self maps\mp\perks\_perks::givePerk("specialty_lightweight");
			self setMoveSpeedScale(1.2);
		}
		
		if(self.perkz["lightweight"] == 2)
		{
			if(!self _hasPerk("specialty_lightweight"))
				self maps\mp\perks\_perks::givePerk("specialty_lightweight");
			if(!self _hasPerk("specialty_fastsprintrecovery"))
				self maps\mp\perks\_perks::givePerk("specialty_fastsprintrecovery");
			self setMoveSpeedScale(1.5);
		}
		
		if(self.perkz["finalstand"] == 2 || (self.humanfs && self.team == "allies"))
		{
			if(!self _hasPerk("specialty_finalstand"))
				self maps\mp\perks\_perks::givePerk("specialty_finalstand");
		}
		wait 1;
	}

}

monitorThrowingKnife()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		if (self getWeaponAmmoClip("throwingknife_mp") > 0)
		{
			if (self.throwingknife == 0)
				self.throwingknife = 1;
		}
		else
		{
			if (self.throwingknife == 1)
				self.throwingknife = 0;
		}
		wait .04;
	}
}

killstreakUsePressed(item)
{
	streakName = item;
	lifeId = -1;

	assert( isDefined( streakName ) );
	assert( isDefined( level.killstreakFuncs[ streakName ] ) );

	if ( !self isOnGround() && ( maps\mp\killstreaks\_killstreaks::isRideKillstreak( streakName ) || maps\mp\killstreaks\_killstreaks::isCarryKillstreak( streakName ) ) )
		return ( 1 );

	if ( self isUsingRemote() )
		return ( 2 );

	if ( isDefined( self.selectingLocation ) )
		return ( 3 );
		
	if ( maps\mp\killstreaks\_killstreaks::deadlyKillstreak( streakName ) && level.killstreakRoundDelay && getGametypeNumLives() )
	{
		if ( level.gracePeriod - level.inGracePeriod < level.killstreakRoundDelay )
		{
			self iPrintLnBold( &"MP_UNAVAILABLE_FOR_N", (level.killstreakRoundDelay - (level.gracePeriod - level.inGracePeriod)) );
			return ( 4 );
		}
	}

	if ( (level.teamBased && level.teamEMPed[self.team]) || (!level.teamBased && isDefined( level.empPlayer ) && level.empPlayer != self) )
	{
		self iPrintLnBold( &"MP_UNAVAILABLE_WHEN_EMP" );
		return ( 5 );
	}

	if ( self IsUsingTurret() && ( maps\mp\killstreaks\_killstreaks::isRideKillstreak( streakName ) || maps\mp\killstreaks\_killstreaks::isCarryKillstreak( streakName ) ) )
	{
		self iPrintLnBold( &"MP_UNAVAILABLE_USING_TURRET" );
		return ( 6 );
	}

	if ( isDefined( self.lastStand )  && maps\mp\killstreaks\_killstreaks::isRideKillstreak( streakName ) )
	{
		self iPrintLnBold( &"MP_UNAVILABLE_IN_LASTSTAND" );
		return ( 7 );
	}
	
	if ( !self isWeaponEnabled() )
		return ( 8 );
	
	if ( !self [[ level.killstreakFuncs[ streakName ] ]]( lifeId ) )
		return ( 9 );

	return ( 0 );
}

tryUsekillstreak(name, cost, item)
{
	ret = self killstreakUsePressed(item);
	if (ret == 0)
	{
		self statCashSub(cost);
		self iPrintlnBold("^2Bought " + name + "!");
		self notify("CASH");
	}
}

buyKillstreak(name, cost, item)
{
		if (self.bounty >= cost)
		{
				self thread tryUsekillstreak(name, cost, item);
		}
		else
				{
					self iPrintlnBold("^1Not Enough ^3Cash");
				}
}

switchToLast()
{
	self switchToWeapon(self.lastweap);
}

waitWeapSwitchRepair()
{
	self endon("disconnect");
	self endon("death");
	for (;;)
	{
		self waittill("delayedweapswitch");
		wait 1.3;
		if (self getCurrentWeapon() == "defaultweapon_mp"){
			self takeWeapon("defaultweapon_mp");
			self switchToLast();
		}
	}
}

monitorRepair()
{
	self endon("disconnect");
	self endon("death");
	self thread waitWeapSwitchRepair();
	while (true)
	{
		if (self getCurrentWeapon() == "defaultweapon_mp" && self.rp > 0)
		{
			self.isRepairing = true;
			self setWeaponAmmoClip("defaultweapon_mp", 0);
		}
		else
		{
			if (self getCurrentWeapon() != "defaultweapon_mp" && !self isChangingWeapon() && self.isRepairing)
				self.isRepairing = false;
			if (self getCurrentWeapon() != "defaultweapon_mp")
				self.lastweap = self getCurrentWeapon();
		}
		wait 0.8;
	}
}

switchToRepair()
{
	if (self getCurrentWeapon() != "defaultweapon_mp")
		self.lastweap = self getCurrentWeapon();
	self giveWeapon("defaultweapon_mp");
	self switchToWeapon("defaultweapon_mp");
}

doHumanShop()
{
	self endon("disconnect");
	self endon("death");
	button = 0;
	
	while(1)
	{
		button = 0;
		if (self.buttonPressed[ "+smoke" ] == 1)
		{
			button = 1;
			self.buttonPressed[ "+smoke" ] = 0;
		}
		else
			if (self.buttonPressed[ "+actionslot 2" ] == 1)
			{
				button = 2;
				self.buttonPressed[ "+actionslot 2" ] = 0;
			}
			else
				if (self.buttonPressed[ "+actionslot 4" ] == 1)
				{
					button = 3;
					self.buttonPressed[ "+actionslot 4" ] = 0;
				}
		
		if (!(self isUsingRemote()))
			if (self.creditshop == false)
			{
				switch(button)
				{
					case 1:
					//FIRST BUTTON
					{
						if (self.menu == 6)
						{
							self buyKillstreak("Sentry", level.itemCost["sentry"], "sentry");
						}
						else
						if (self.menu == 5)
						{
							if(self.bounty >= self.nuke_price && !isDefined(level.nukeIncoming))
							{
									self statCashSub(self.nuke_price);
									self maps\mp\killstreaks\_killstreaks::giveKillstreak("nuke", false);
									self switchToWeapon("killstreak_nuke_mp");
									foreach (player in level.players)
										player thread maps\mp\gametypes\_hud_message::hintMessage("^2The End is Nigh!");
							}
							else
									{
										if (!isDefined(level.nukeIncoming))
											self iPrintlnBold("^3TACTICAL NUKE ^1DENIED!");
										else
											self iPrintLnBold( &"MP_NUKE_ALREADY_INBOUND" );
									}
						}
						else
						if (self.menu == 0)
						{
							if(self.bounty >= level.itemCost["ammo"])
							{
								self statCashSub(level.itemCost["ammo"]);
								primaryWeapons = self getWeaponsListPrimaries();
								foreach ( primary in primaryWeapons )
								{
									self GiveMaxAmmo(primary);
								}
								self.nades = getDefaultNadeAmmo(self.nadetype);
							}
							else
								{
									self iPrintlnBold("^1Not Enough ^3Cash");
								}
						}
						else
						if (self.menu == 1)
						{
							if(self.attach["akimbo"] == 1)
							{
								if(self.bounty >= level.itemCost["Akimbo"])
									{
										self statCashSub(level.itemCost["Akimbo"]);
										ammo = self GetWeaponAmmoStock(self.current);
										basename = strtok(self.current, "_");
										gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "akimbo");
										self takeWeapon(self.current);
										self giveWeapon(gun , 0, true);
										self SetWeaponAmmoStock( gun, ammo );
										self switchToWeapon(gun);
										self iPrintlnBold("^2Weapon Upgraded!");
									}
									else
										{
												self iPrintlnBold("^1Not Enough ^3Cash");
										}
							}
						}
						else
						if (self.menu == 2)
						{
							if(self.attach["silencer"] == 1)
							{
								if(self.bounty >= level.itemCost["Silencer"])
								{
									self statCashSub(level.itemCost["Silencer"]);
									ammo = self GetWeaponAmmoStock(self.current);
									basename = strtok(self.current, "_");
									gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "silencer");
									self takeWeapon(self.current);
									if(self.attach1[self.currentweapon] == "akimbo")
										{
											self giveWeapon(gun , 0, true);
										}
										else
											{
												self giveWeapon(gun , 0, false);
											}
									self SetWeaponAmmoStock( gun, ammo );
									self switchToWeapon(gun);
									self iPrintlnBold("^2Weapon Upgraded!");
								}
								else
									{
										self iPrintlnBold("^1Not Enough ^3Cash");
									}
							}
						}
						if (self.menu == 3)
						{
							switch(self.perkz["steadyaim"])
							{
								case 0:
									if(self.bounty >= level.itemCost["SteadyAim"])
									{
										self statCashSub(level.itemCost["SteadyAim"]);
										self.perkz["steadyaim"] = 1;
										self iPrintlnBold("^2Perk Bought!");
									}
									else
									{
										self iPrintlnBold("^1Not Enough ^3Cash");
									}
									break;
									case 1:
										if(self.bounty >= level.itemCost["SteadyAimPro"])
										{
											self statCashSub(level.itemCost["SteadyAimPro"]);
											self.perkz["steadyaim"] = 2;
											self iPrintlnBold("^2Perk Upgraded!");
										}
										else
											{
												self iPrintlnBold("^1Not Enough ^3Cash");
											}
										break;
									default:
									break;
							}
						}
						else
						if (self.menu == 4)
						{
								switch(self.perkz["stoppingpower"])
								{
									case 0:
										if(self.bounty >= level.itemCost["StoppingPower"])
											{
												self statCashSub(level.itemCost["StoppingPower"]);
												self.perkz["stoppingpower"] = 1;
												self iPrintlnBold("^2Perk Bought!");
											}
											else
												{
													self iPrintlnBold("^1Not Enough ^3Cash");
												}
										break;
									case 1:
										if(self.bounty >= level.itemCost["StoppingPowerPro"])
											{
												self statCashSub(level.itemCost["StoppingPowerPro"]);
												self.perkz["stoppingpower"] = 2;
												self iPrintlnBold("^2Perk Upgraded!");
											}
											else
											{
												self iPrintlnBold("^1Not Enough ^3Cash");
											}
									break;
									default:
										break;
							}
						}
						else
						if (self.menu == 7)
						{
							self buyKillstreak("Harrier", level.itemCost["harrier"], "harrier_airstrike");
						}
						else
						if (self.menu == 8)
						{
										if(self.bounty >= level.itemCost["artillery"])
											{
												self.bounty -= level.itemCost["artillery"];
												ArtilleryStrike();
												self notify("CASH");
											}
											else
											{
													self iPrintlnBold("^1Not Enough ^3Cash");
											}
						}
						wait .1;
						
					}
					break;
					case 2:
					//SECOND BUTTON
					{
						if (self.menu == 6)
						{
							self buyKillstreak("Pave Low", level.itemCost["pavelow"], "helicopter_flares");
						}
						else
						if (self.menu == 0)
						{
							self thread doExchangeWeapons();
						}
						else
						if (self.menu == 1)
						{
							if(self.attach["fmj"] == 1)
								{
									if(self.bounty >= level.itemCost["FMJ"])
									{
										self statCashSub(level.itemCost["FMJ"]);
										ammo = self GetWeaponAmmoStock(self.current);
										basename = strtok(self.current, "_");
										gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "fmj");
										self takeWeapon(self.current);
										if(self.attach1[self.currentweapon] == "akimbo")
										{
											self giveWeapon(gun , 0, true);
										}
										else
											{
												self giveWeapon(gun , 0, false);
											}
										self SetWeaponAmmoStock( gun, ammo );
										self switchToWeapon(gun);
										self iPrintlnBold("^2Weapon Upgraded!");
									}
									else
										{
											self iPrintlnBold("^1Not Enough ^3Cash");
										}
								}
						}
						else
						if (self.menu == 2)
						{
								if(self.attach["xmags"] == 1)
									{
										if(self.bounty >= level.itemCost["XMags"])
											{
												self statCashSub(level.itemCost["XMags"]);
												ammo = self GetWeaponAmmoStock(self.current);
												basename = strtok(self.current, "_");
												gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "xmags");
												self takeWeapon(self.current);
												if(self.attach1[self.currentweapon] == "akimbo")
													{
														self giveWeapon(gun , 0, true);
													}
													else
														{
															self giveWeapon(gun , 0, false);
														}
												self SetWeaponAmmoStock( gun, ammo );
												self switchToWeapon(gun);
												self iPrintlnBold("^2Weapon Upgraded!");
											}
											else
												{
													self iPrintlnBold("^1Not Enough ^3Cash");
												}
									}
						}
						else
						if (self.menu == 3)
						{
							switch(self.perkz["sleightofhand"]){case 0:if(self.bounty >= level.itemCost["SleightOfHand"]){
							self statCashSub(level.itemCost["SleightOfHand"]);
							self.perkz["sleightofhand"] = 1;
							self iPrintlnBold("^2Perk Bought!");
							} else {self iPrintlnBold("^1Not Enough ^3Cash");
							}
							break;
							case 1:
							if(self.bounty >= level.itemCost["SleightOfHandPro"]){
							self statCashSub(level.itemCost["SleightOfHandPro"]);
							self.perkz["sleightofhand"] = 2;
							self iPrintlnBold("^2Perk Upgraded!");
							} else {self iPrintlnBold("^1Not Enough ^3Cash");
							}break;
							default:
								break;
							}
						}
						else
						if(self.menu == 4)
						{
								if(self.attach["acog"] == 1)
								{
									if (self.bounty >= level.itemCost["acog"])
									{
										self statCashSub(level.itemCost["acog"]);
										ammo = self GetWeaponAmmoStock(self.current);
										basename = strtok(self.current, "_");
										gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "acog");
										self takeWeapon(self.current);
										if(self.attach1[self.currentweapon] == "akimbo")
										{
											self giveWeapon(gun , 0, true);
										}
										else
										{
											self giveWeapon(gun , 0, false);
										}
										self SetWeaponAmmoStock( gun, ammo );
										self switchToWeapon(gun);
										self iPrintlnBold("^2Weapon Upgraded!");
									}
									else
										self iPrintlnBold("^1Not Enough ^3Cash");
								}
						}
						else
						if (self.menu == 5)
						{
							if (self.bounty >= level.itemCost["rifle"])
							{
								self statCashSub(level.itemCost["rifle"]);
								self.randomsr = randomInt(4);
								self takeWeapon(self.current);
								self giveWeapon(level.rifle[self.randomsr] + "_mp", 0, false);
								self switchToWeapon(level.rifle[self.randomsr] + "_mp");
								if (self.fullammo == true)
									self GiveMaxAmmo(level.rifle[self.randomsr] + "_mp");
								else
									self GiveStartAmmo(level.rifle[self.randomsr] + "_mp");
								self iPrintlnBold("^2Bought Sniper Rifle!");
							}
							else
								{
									self iPrintlnBold("^1Not Enough ^3Cash");
								}
						}
						else
						if (self.menu == 7)
						{
							if (self.rp <= 0)
								if (self.bounty >= level.itemCost["repair"])
								{
										self statCashSub(level.itemCost["repair"]);
										self.rp = getDvarInt("scr_zmod_repair_points");
										self iPrintlnBold("^2Bought Door Repair Tool!");
										self switchToRepair();
								}
								else
									self iPrintlnBold("^1Not Enough ^3Cash");
							else
								if (self.isRepairing)
									self switchToLast();
								else
									self switchToRepair();
						}
						else
						if (self.menu == 8)
						{
										if(self.bounty >= level.itemCost["airstrike"])
											{
												self.bounty -= level.itemCost["airstrike"];
												tryUseCustomAirstrike();
												self notify("CASH");
											}
											else
											{
													self iPrintlnBold("^1Not Enough ^3Cash");
											}
						}
						wait .1;
					}
					break;
					case 3:
					//Third button
					{
						if (self.menu == 6)
						{
							self buyKillstreak("Chopper Gunner", level.itemCost["choppergunner"], "helicopter_minigun");
						}
						else
						if (self.menu == 0)
						{
							if(self.bounty >= level.itemCost["Riot"])
							{
								self statCashSub(level.itemCost["Riot"]);
								self giveWeapon("riotshield_mp", 0, false);
								self switchToWeapon("riotshield_mp");
								self iPrintlnBold("^2Riot Shield Bought!");
							}
							else
								{
									self iPrintlnBold("^1Not Enough ^3Cash");
								}
						}
						else
						if (self.menu == 1)
						{
							if((self.attach["eotech"] == 1 && self.eotech == true) || (self.attach["reddot"] == 1 && self.eotech == false))
							{
								if(self.bounty >= level.itemCost["Eotech"])
								{
									self statCashSub(level.itemCost["Eotech"]);
									ammo = self GetWeaponAmmoStock(self.current);
									basename = strtok(self.current, "_");
									aname = "reflex";
									if (self.eotech)
										aname = "eotech";
									gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], aname);
									self takeWeapon(self.current);
									if(self.attach1[self.currentweapon] == "akimbo")
									{
										self giveWeapon(gun , 0, true);
									}
									else
									{
										self giveWeapon(gun , 0, false);
									}
									self SetWeaponAmmoStock( gun, ammo );
									self switchToWeapon(gun);
									self iPrintlnBold("^2Weapon Upgraded!");
								}
								else
									{
										self iPrintlnBold("^1Not Enough ^3Cash");
									}
							}
						}
						else
						if (self.menu == 2)
						{
							if(self.attach["rof"] == 1)
							{
								if(self.bounty >= level.itemCost["ROF"])
								{
									self statCashSub(level.itemCost["ROF"]);
									ammo = self GetWeaponAmmoStock(self.current);
									basename = strtok(self.current, "_");
									gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "rof");
									self takeWeapon(self.current);
									if(self.attach1[self.currentweapon] == "akimbo")
									{
										self giveWeapon(gun , 0, true);
									}
									else
									{
										self giveWeapon(gun , 0, false);
									}
									self SetWeaponAmmoStock( gun, ammo );
									self switchToWeapon(gun);
									self iPrintlnBold("^2Weapon Upgraded!");
								}
								else
									{
										self iPrintlnBold("^1Not Enough ^3Cash");
									}
							}
						}
						else
						if (self.menu == 3)
						{
							if(self.bounty >= level.itemCost["rpg7"])
							{
								self statCashSub(level.itemCost["rpg7"]);
								if (self.hasROFL == true)
								{
									self thread roflloop();
									self.hasROFL = false;
									self giveWeapon("stinger_mp", 0, false);
									self switchToWeapon("stinger_mp");
									self iPrintlnBold("^2ROFL Launcher Bought!");
								}
								else
								{
								self giveWeapon("rpg_mp", 0, false);
								self switchToWeapon("rpg_mp");
								self iPrintlnBold("^2RPG-7 Bought!");
								}
							}
							else
								{
									self iPrintlnBold("^1Not Enough ^3Cash");
								}
						}
						else
						if (self.menu == 4)
						{
							self buyKillstreak("Predator Strike", level.itemCost["pmissile"], "predator_missile");
						}
						else
						if (self.menu == 5)
						{
							self buyKillstreak("AC-130 Gunship", level.itemCost["ac130"], "ac130");
						}
						else
						if (self.menu == 7)
						{
							//Previous Trading Function
						}
						else
						if (self.menu == 8)
						{
										if(self.bounty >= level.itemCost["GrimReaper"])
											{
												self.bounty -= level.itemCost["GrimReaper"];
												GrimReaper();
												self notify("CASH");
											}
											else
											{
													self iPrintlnBold("^1Not Enough ^3Cash");
											}
						}
						wait .1;
					}
					break;
					default:
					break;
				}
			}
			else
			{
				switch(button)
				{
					case 1:
					//FIRST BUTTON
					if (level.creditM[self.menu][0]["text"] != ""){
						cost = level.creditM[self.menu][0]["cost"];
						if (self.credits < cost)
						{
							self iPrintlnBold("^1Not enough ^5CREDITS");
							continue;
						}
						
						
						switch(self.menu)
						{
							case 0:
								if (self.humancash == true)
									self iPrintlnBold("^1Already bought Human Starting Cash!");
								else
								{
									self.humancash = true;
									self statCreditsSub(cost);
									self iPrintlnBold("^2Bought ^5Human Starting Cash");
								}
								break;
							case 1:
								if (self.atk >= 3)
									self iPrintlnBold("^1Door ATK is at max!");
								else
									{
										self.atk++;
										self statCreditsSub(cost);
										self iPrintlnBold("^2Bought ^5Increased Door ATK");
									}
								break;
							case 2:
								if (self.cheapnuke == true)
									self iPrintlnBold("^1Already bought Cheaper Nuke!");
								else
									{
										self.cheapnuke = true;
										self statCreditsSub(cost);
										self iPrintlnBold("^2Bought ^5Cheaper Nuke!");
									}
								break;
							case 3:
								if (self.eotech == true)
									self iPrintlnBold("^1Already bought Holographic Sight!");
								else
									{
										self.eotech = true;
										self statCreditsSub(cost);
										self iPrintlnBold("^2Bought ^5Holographic Sight!");
									}
								break;
							case 4:
								if (self.tact == true)
										self iPrintlnBold("^1Already bought Tactical Insertion for Lives!");
								else
								{
									self.tact = true;
									self statCreditsSub(cost);
									self iPrintlnBold("^2Bought ^5Tactical Insertion for Lives!");
								}
								break;
						}
						self notify("CASH");
					}
					break;
					case 2:
					//SECOND BUTTON
					if (level.creditM[self.menu][1]["text"] != ""){
						cost = level.creditM[self.menu][1]["cost"];
						if (self.credits < cost)
						{
							self iPrintlnBold("^1Not enough ^5CREDITS");
							continue;
						}
						
						
						switch(self.menu)
						{
							case 0:
								if (self.zombiecash == true)
									self iPrintlnBold("^1Already bought Zombie Starting Cash");
								else
								{
									self.zombiecash = true;
									self statCreditsSub(cost);
									self iPrintlnBold("^2Bought ^5Zombie Starting Cash!");
								}
								break;
							case 1:
								if (self.antialpha == true)
									self iPrintlnBold("^1Already bought Anti-Alpha!");
								else
								{
									self.antialpha = true;
									self statCreditsSub(cost);
									self iPrintlnBold("^2Bought ^5Anti-Alpha!");
								}
								break;
							case 2:
								if (self.commandopro == true)
									self iPrintlnBold("^1Already bought Commando Pro for LPA!");
								{
									self.commandopro = true;
									self statCreditsSub(cost);
									self iPrintlnBold("^2Bought ^5Commando Pro fpr LPA!");
								}
								break;
							case 3:
								if (self.nadetype >= level.nadetypes.size - 1)
									self iPrintlnBold("^1Cannot upgrade any further!");
								else
								{
									self.nadetype++;
									self statCreditsSub(cost);
									weap = level.nadenames[self.nadetype];
									self iPrintlnBold("^2Bought ^5" + weap + " Upgrade!");
								}
								break;
							case 4:
								if (self.riotz == true)
										self iPrintlnBold("^1Already unlocked Riot Shield for Zombies!");
								else
								{
									self.riotz = true;
									self statCreditsSub(cost);
									self iPrintlnBold("^2Unlocked ^5Riot Shield for Zombies!");
								}
								break;
						}
						self notify("CASH");
					}
					break;
					case 3:
					// Third button
					if (level.creditM[self.menu][2]["text"] != ""){
						cost = level.creditM[self.menu][2]["cost"];
						if (self.credits < cost)
						{
							self iPrintlnBold("^1Not enough ^5CREDITS");
							continue;
						}
						
						switch(self.menu)
						{
							case 0:
								if (self.fullammo == true)
									self iPrintlnBold("^1Already bought Full Ammo Upgrades");
								else
									{
										self.fullammo = true;
										self statCreditsSub(cost);
										self iPrintlnBold("^2Bought ^5Full Ammo for Upgrades!");
									}
								break;
							case 1:
								if (self.lives >= level.maxlives)
									self iPrintlnBold("^1Max lives achieved!");
								else
									{
										self statLivesInc();
										self statCreditsSub(cost);
										self iPrintlnBold("^2Bought ^5an extra life!");
									}
								break;
							case 2:
								if (self.hasROFL == true)
										self iPrintLnBold("^1Already bought ROFL Launcher");
								else
									{
										self.hasROFL = true;
										self statCreditsSub(cost);
										self iPrintlnBold("^2Bought ^5The ROFL Launcher!");
									}
								break;
							case 3:
								if (self.humanfs)
									self iPrintLnBold("^1Already bought Final Stand!");
								else
									{
										self.humanfs = true;
										self statCreditsSub(cost);
										self iPrintlnBold("^2Bought ^5Final Stand!");
									}
								break;
						}
						self notify("CASH");
					}
					break;
				}
			}
		wait .1;
	}
}

doZombieShop()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		//First Button
		if(self.buttonPressed[ "+smoke" ] == 1)
		{
			self.buttonPressed[ "+smoke" ] = 0;
			if(self.menu == 0)
			{
				if(self.maxhp < 1000)
					{
						if(self.bounty >= level.itemCost["health"])
							{
								self statCashSub(level.itemCost["health"]);
								self statMaxHealthAdd(level.itemCost["health"]);
								self iPrintlnBold("^2Health Increased!");
							}
						else
							{
								self iPrintlnBold("^1Not Enough ^3Cash");
							}
					}
				else
					{
							self iPrintlnBold("^1Max Health Achieved!");
					}
			}
			if(self.menu == 1)
			{
				switch(self.perkz["coldblooded"])
				{
					case 0:
						if(self.bounty >= level.itemCost["ColdBlooded"])
							{
								self statCashSub(level.itemCost["ColdBlooded"]);
								self.perkz["coldblooded"] = 1;
								self iPrintlnBold("^2Perk Bought!");
							}
							else
								{
									self iPrintlnBold("^1Not Enough ^3Cash");
								}
							break;
					case 1:
						if(self.bounty >= level.itemCost["ColdBloodedPro"])
							{
								self statCashSub(level.itemCost["ColdBloodedPro"]);
								self.perkz["coldblooded"] = 2;
								self iPrintlnBold("^2Perk Upgraded!");
							}
							else
								{
									self iPrintlnBold("^1Not Enough ^3Cash");
								}
							break;
					default:
							break;
				}
			}
			if(self.menu == 2)
			{
				switch(self.perkz["finalstand"])
				{
					case 0:
						if(self.bounty >= level.itemCost["FinalStand"])
							{
								self statCashSub(level.itemCost["FinalStand"]);
								self.perkz["finalstand"] = 2;
								self iPrintlnBold("^2Perk Bought!");
							}
							else
								{
									self iPrintlnBold("^1Not Enough ^3Cash");
								}
					break;
				default:
					break;
				}
			}
			if (self.menu == 3)
			{
					if (self.blastshield)
						self maps\mp\perks\_perkfunctions::toggleBlastShield(self _hasPerk("_specialty_blastshield"));
					else
						if (self.bounty >= level.itemCost["blastshield"])
						{
							self.blastshield = true;
							self statCashSub(level.itemCost["blastshield"]);
							self maps\mp\perks\_perkfunctions::toggleBlastShield(false);
							self iPrintlnBold("^2Bought Blast Shield!");
						}
						else
							self iPrintlnBold("^1Not Enough ^3Cash");
			}
			wait .1;
		}	
		//Second button
		if(self.buttonPressed[ "+actionslot 2" ] == 1)
		{
			self.buttonPressed[ "+actionslot 2" ] = 0;
			if(self.menu == 0)
			{
				if(self.thermal == 0)
				{
					if(self.bounty >= level.itemCost["Thermal"])
					{
						self statCashSub(level.itemCost["Thermal"]);
						self ThermalVisionFOFOverlayOn();
						self.thermal = 1;
						self iPrintlnBold("^2Thermal Vision Overlay Activated!");
					}
					else
					{
						self iPrintlnBold("^1Not Enough ^3Cash");
					}
				}
				else
				{
					self iPrintlnBold("^1Thermal already activated!");
				}
			}
			if(self.menu == 1)
			{
				switch(self.perkz["ninja"])
				{
					case 0:
						if(self.bounty >= level.itemCost["Ninja"])
						{
							self statCashSub(level.itemCost["Ninja"]);
							self.perkz["ninja"] = 1;
							self iPrintlnBold("^2Perk Bought!");
							self notify("CASH");
						}
						else
							{
								self iPrintlnBold("^1Not Enough ^3Cash");
							}
						break;
					case 1:
						if(self.bounty >= level.itemCost["NinjaPro"])
						{
							self statCashSub(level.itemCost["NinjaPro"]);
							self.perkz["ninja"] = 2;
							self iPrintlnBold("^2Perk Upgraded!");
						}
						else
							{
								self iPrintlnBold("^1Not Enough ^3Cash");
							}
						break;
					default:
						break;
				}
			}
			if (self.menu == 2)
			{
				if (self getWeaponAmmoClip("stinger_mp") == 0)
						if (self.bounty >= level.itemCost["stinger"])
						{
							self statCashSub(level.itemCost["stinger"]);
							self giveWeapon("stinger_mp", 0, false);
							self switchToWeapon("stinger_mp");
							self GiveStartAmmo("stinger_mp");
							self.stinger = self getWeaponAmmoClip("stinger_mp") + self getWeaponAmmoStock("stinger_mp");
							self thread monitorStinger();
							//clog("Total stinger ammo: " + self.stinger);
							self iPrintlnBold("^2Bought Stinger!");
						}
						else
							{
								self iPrintlnBold("^1Not Enough ^3Cash");
							}
				else
					self iPrintlnBold("^1Already have Stinger!");
			}
			if (self.menu == 3)
			{
				if (self hasWeapon("riotshield_mp"))
					self iPrintlnBold("^2Already have Riot Shield!");
				else
						if (!self.riotz)
							self iPrintlnBold("^1You have not unlocked this item!");
						else
							if (self.bounty >= level.itemCost["riotz"])
							{
									self giveWeapon("riotshield_mp", 0, false);
									self switchToWeapon("riotshield_mp");
									self statCashSub(level.itemCost["riotz"]);
									self iPrintlnBold("^2Bought Riot Shield! GO GET EM!");
							}
							else
								self iPrintlnBold("^1Not Enough ^3Cash");
			}
			wait .1;
		}
		//Third button
		if(self.buttonPressed[ "+actionslot 4" ] == 1)
		{
			self.buttonPressed[ "+actionslot 4" ] = 0;
			if(self.menu == 0)
			{
				if(self getWeaponAmmoClip("throwingknife_mp") == 0)
				{
					if(self.bounty >= level.itemCost["ThrowingKnife"])
					{
						self statCashSub(level.itemCost["ThrowingKnife"]);
						self thread monitorThrowingKnife();
						self maps\mp\perks\_perks::givePerk( "throwingknife_mp" );
						self setWeaponAmmoClip("throwingknife_mp", 1);
						self.throwingknife = 1;
						self iPrintlnBold("^2Throwing Knife Purchased");
					}
					else
						{
							self iPrintlnBold("^1Not Enough ^3Cash");
						}
				}
				else
				{
					self iPrintlnBold("^1You have too many knives!");
				}
			}
			if(self.menu == 1)
			{
				switch(self.perkz["lightweight"])
				{
					case 0:
						if(self.bounty >= level.itemCost["Lightweight"])
						{
							self statCashSub(level.itemCost["Lightweight"]);
							self.perkz["lightweight"] = 1;
							self iPrintlnBold("^2Perk Bought!");
						}
						else
							{
								self iPrintlnBold("^1Not Enough ^3Cash");
							}
						break;
					case 1:
						if(self.bounty >= level.itemCost["LightweightPro"])
						{
							self statCashSub(level.itemCost["LightweightPro"]);
							self.perkz["lightweight"] = 2;
							self iPrintlnBold("^2Perk Upgraded!");
						}
						else
							{
								self iPrintlnBold("^1Not Enough ^3Cash");
							}
						break;
					default:
						break;
				}
			}
			if (self.menu == 2)
			{
				self suicide();
					
			}
			wait .1;
		}
		wait .1;
	}
}

doExchangeWeapons()
{
	switch(self.exTo)
	{
		case "LMG":
			if	(self.bounty >= level.itemCost["LMG"])
				{
					self statCashSub(level.itemCost["LMG"]);
					self.randomlmg = randomInt(level.lmg.size);
					self takeWeapon(self.current);
					self giveWeapon(level.lmg[self.randomlmg] + "_mp", 0, false);
					if (self.fullammo == true)
						self GiveMaxAmmo(level.lmg[self.randomlmg] + "_mp");
					else
						self GiveStartAmmo(level.lmg[self.randomlmg] + "_mp");
					self switchToWeapon(level.lmg[self.randomlmg] + "_mp");
					self iPrintlnBold("^2Light Machine Gun Bought!");
				}
				else
					{
						self iPrintlnBold("^1Not Enough ^3Cash");
					}
		break;
		case "Assault Rifle":
			if (self.bounty >= level.itemCost["Assault Rifle"])
				{
					self statCashSub(level.itemCost["Assault Rifle"]);
					self.randomar = randomInt(level.assault.size);
					self takeWeapon(self.current);
					self giveWeapon(level.assault[self.randomar] + "_mp", 0, false);
					if (self.fullammo == true)
						self GiveMaxAmmo(level.assault[self.randomar] + "_mp");
					else
						self GiveStartAmmo(level.assault[self.randomar] + "_mp");
					self switchToWeapon(level.assault[self.randomar] + "_mp");
					self iPrintlnBold("^2Assault Rifle Bought!");
				}
				else
					{
						self iPrintlnBold("^1Not Enough ^3Cash");
					}
		break;
		case "Machine Pistol":
			if(self.bounty >= level.itemCost["Machine Pistol"])
			{
				self statCashSub(level.itemCost["Machine Pistol"]);
				self.randommp = randomInt(level.machine.size);
				self takeWeapon(self.current);
				self giveWeapon(level.machine[self.randommp] + "_mp", 0, false);
				if (self.fullammo == true)
					self GiveMaxAmmo(level.machine[self.randommp] + "_mp");
				else
					self GiveStartAmmo(level.machine[self.randommp] + "_mp");
				self switchToWeapon(level.machine[self.randommp] + "_mp");
				self iPrintlnBold("^2Machine Pistol Bought!");
			}
			else
				{
					self iPrintlnBold("^1Not Enough ^3Cash");
				}
		break;
		case "smg":
			if (self.bounty >= level.itemCost["smg"])
			{
				self statCashSub(level.itemCost["smg"]);
				self.randomsmg = randomInt(level.smg.size);
				self takeWeapon(self.current);
				self giveWeapon(level.smg[self.randomsmg] + "_mp", 0, false);
				if (self.fullammo == true)
					self GiveMaxAmmo(level.smg[self.randomsmg] + "_mp");
				else
					self GiveStartAmmo(level.smg[self.randomsmg] + "_mp");
				self switchToWeapon(level.smg[self.randomsmg] + "_mp");
				self iPrintlnBold("^2SMG Bought!");
			}
			else
				{
					self iPrintlnBold("^1Not Enough ^3Cash");
				}
		break;
		default:
		break;
	}
	
}

buildWeaponName( baseName, attachment1, attachment2 )
{
	if( !isDefined( level.letterToNumber ) )
	{
			level.letterToNumber = makeLettersToNumbers();
	}
	if ( getDvarInt ( "scr_game_perks" ) == 0 )
	{
		attachment2 = "none";
		if ( baseName == "onemanarmy" )
		{
			return ( "beretta_mp" );
		}
	}
	weaponName = baseName;
	attachments = [];
	if ( attachment1 != "none" && attachment2 != "none" )
	{
		if ( level.letterToNumber[attachment1[0]] < level.letterToNumber[attachment2[0]] )
		{
			attachments[0] = attachment1;
			attachments[1] = attachment2;
		}
		else
			if ( level.letterToNumber[attachment1[0]] == level.letterToNumber[attachment2[0]] )
			{
				if ( level.letterToNumber[attachment1[1]] < level.letterToNumber[attachment2[1]] )
				{
					attachments[0] = attachment1;
					attachments[1] = attachment2;
				}
				else
					{
						attachments[0] = attachment2;
						attachments[1] = attachment1;
					}
			}
			else
				{
					attachments[0] = attachment2;
					attachments[1] = attachment1;
				}
	}
	else
		if ( attachment1 != "none" )
		{
			attachments[0] = attachment1;
		}
		else
			if ( attachment2 != "none" )
			{
				attachments[0] = attachment2;
			}
	foreach ( attachment in attachments )
	{
		weaponName += "_" + attachment;
	}
	return ( weaponName + "_mp" );
}

makeLettersToNumbers()
{
	array = [];
	array["a"] = 0;
	array["b"] = 1;
	array["c"] = 2;
	array["d"] = 3;
	array["e"] = 4;
	array["f"] = 5;
	array["g"] = 6;
	array["h"] = 7;
	array["i"] = 8;
	array["j"] = 9;
	array["k"] = 10;
	array["l"] = 11;
	array["m"] = 12;
	array["n"] = 13;
	array["o"] = 14;
	array["p"] = 15;
	array["q"] = 16;
	array["r"] = 17;
	array["s"] = 18;
	array["t"] = 19;
	array["u"] = 20;
	array["v"] = 21;
	array["w"] = 22;
	array["x"] = 23;
	array["y"] = 24;
	array["z"] = 25;
	return array;
}

isValidWeapon( refString )
{
	if ( !isDefined( level.weaponRefs ) )
	{
		level.weaponRefs = [];
		foreach ( weaponRef in level.weaponList )
		{
			level.weaponRefs[ weaponRef ] = true;
		}
	}
	if ( isDefined( level.weaponRefs[ refString ] ) )
	{
		return true;
	}
	assertMsg( "Replacing invalid weapon/attachment combo: " + refString );
	return false;
}

doGameStarter()
{
	
	level.gameState = "starting";
	level notify("gamestatechange");
	level.maxlives = getDvarInt("scr_zmod_max_lives");
	level.lastAlive = 0;
	level waittill("CREATED");
	level thread doStartTimer();
	foreach(player in level.players)
	{
		player thread doSetup();
	}
	wait getdvarint("scr_zmod_starting_time");
	level thread doZombieTimer();
	if (getdvarint("scr_zmod_darken"))
		VisionSetNaked("icbm", 5);
}

doStartTimer()
{
	level.counter = getdvarint("scr_zmod_starting_time");
	while(level.counter > 0)
	{
		level.TimerText destroy();
		level.TimerText = level createServerFontString( "objective", 1.5 );
		level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
		level.TimerText setText("^2Game Starting in: " + level.counter);
		setDvar("fx_draw", 1);
		wait 1;
		level.counter--;
	}
	level.TimerText setText("");
	first_round_init();
	foreach(player in level.players)
	{
		player thread doSetup();
	}
}

getPlace(i)
{
	p = "";
	switch(i % 10)
	{
		case 0:
			i = 1;
		case 1:
			p = "st";
			break;
		case 2:
			p = "nd";
			break;
		case 3:
			p = "rd";
			break;
		default:
			p = "th";
			break;
	}
	return "" + i + p;
}

calculateCredits()
{
	winner_size = 6;
	if (level.players.size < winner_size)
		if (level.players.size > 2)
			winner_size = 1;
		else
			return;

	winners = [];
	zwinners = [];
	there = false;
	max = 0;
	c = -1;
	apply = 0;
	
	while (winners.size < winner_size)
	{
		max = 0;
		c = -1;
		apply = 0;
		for (i = 0; i < level.players.size; i++)
		{
			there = false;
			foreach (w in winners)
			{
				if (w == i)
				{
					there = true;
					break;
				}
			}
			if (there)
				continue;
			if (level.players[i].credit_kills > max && level.players[i].kills < level.players[i].credit_kills)
			{
				c = i;
				max = level.players[i].credit_kills;
				apply++;
			}
		}
		if (apply == 0)
			break;
		winners[winners.size] = c;
		level.players[c].kills = 0;
	}	
	i = 0;
	prize = (winners.size * 50) + 100;
	foreach (w in winners)
	{
		i++;
		p = prize + (25 * level.players[w].credit_kills);
		level.players[w] statCreditsAdd(p);
		level.players[w] setCreditsPersistent();
		level.players[w] iPrintlnBold("^3You earned ^5" + p + " ^3credits! You were ^2" + getPlace(i) + " place as human!");
		prize -= 25;
	}
	
	for (i = 0; i < level.players.size; i++)
		level.players[i].credit_kills = 0;

	while (zwinners.size < winner_size)
	{
		max = 0;
		c = -1;
		apply = 0;
		for (i = 0; i < level.players.size; i++)
		{
			there = false;
			foreach (w in zwinners)
			{
				if (w == i)
				{
					there = true;
					break;
				}
			}
			if (there)
				continue;
			
			if (level.players[i].kills > max)
			{
				c = i;
				max = level.players[i].kills;
				apply++;
			}
			
		}
		if (apply == 0)
			break;
		zwinners[zwinners.size] = c;
	}
		
	i = 0;
	prize = (zwinners.size * 100) + 100;
	foreach (w in zwinners)
	{
		i++;
		p = prize + (50 * level.players[w].kills);
		level.players[w] statCreditsAdd(p);
		level.players[w] setCreditsPersistent();
		level.players[w] iPrintlnBold("^3You earned ^5" + p + " ^3credits! You were ^2" + getPlace(i) + " place as zombie!");
		prize -= 50;
	}
	
	for (i = 0; i < level.players.size; i++)
		level.players[i].kills = 0;
}

doIntermission()
{
	level.gameState = "intermission";
	level notify("gamestatechange");
	level.maxlives = getDvarInt("scr_zmod_max_lives");
	level.lastAlive = 0;
	level thread doIntermissionTimer();

	level notify("RESETDOORS");
	level notify("RESETCLUSTER");
	setDvar("cg_drawCrosshair", 1);
	setDvar("cg_drawCrosshairNames", 1);
	setDvar("cg_drawFriendlyNames", 1);
	dropDead();
	foreach(player in level.players)
		player.bounty = 0;
	
	level.ShowCreditShop = true;
	foreach(player in level.players)
		player thread doSetup();
	
	wait getdvarInt("scr_zmod_intermission_time");
	level.ShowCreditShop = false;
	level thread doZombieTimer();
	CleanupKillstreaks();
	if (getdvarint("scr_zmod_darken") != 0)
		VisionSetNaked("icbm", 5);
}

doIntermissionTimer()
{
	level.counter = getdvarInt("scr_zmod_intermission_time");

	while(level.counter > 0)
	{
		level.TimerText destroy();
		level.TimerText = level createServerFontString( "objective", 1.5 );
		level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
		level.TimerText setText("^2Intermission: " + level.counter);
		setDvar("fx_draw", 1);
		wait 1;
		
		level.counter--;
	}
	level.TimerText setText("");
	foreach(player in level.players)
	{
		player thread doSetup();
	}
}

doZombieTimer()
{
	setDvar("cg_drawCrosshair", 1);
	level.counter = getdvarInt("scr_zmod_alpha_time");

	while(level.counter > 0){
		level.TimerText destroy();
		level.TimerText = level createServerFontString( "objective", 1.5 );
		level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
		level.TimerText setText("^1Alpha Zombie in: " + level.counter);
		wait 1;
		
		level.counter--;
	}
	level.TimerText setText("");
	level thread doPickZombie();
}

chooseZombie()
{
	while(1)
	{
		for (i = 0; i < level.players.size; i++)
		{
			if (level.players[i].wasAlpha == 1 || !level.players[i].ack["safe"])
				continue;
			level.players[i].wasAlpha = 1;
			if (level.players[i].antialpha == true)
			{
				level.players[i].antialpha = false;
				level.players[i] iPrintlnBold("^1Anti-Alpha ^2Used!");
				continue;
			}
			return i;
		}
		for (i = 0; i < level.players.size; i++)
		{
			level.players[i].wasAlpha = 0;
		}
		if (level.players.size == 0)
			return -1;
	}
	return -1;
}

chooseSurvivor()
{
	while(1)
	{
		for (i = 0; i < level.players.size; i++)
		{
			if (level.players[i].wasSurvivor == 1 || !level.players[i].ack["safe"])
				continue;
			level.players[i].wasSurvivor = 1;
			return i;
		}
		for (i = 0; i < level.players.size; i++)
		{
			level.players[i].wasSurvivor = 0;
		}
		if (level.players.size == 0)
			return -1;
	}
}

getNadeWeap()
{
	return level.nadetypes[self.nadetype];
}

getDefaultNadeAmmo(type)
{
	if (type == 0)
		return getDvarInt("scr_zmod_frag_ammo");
	else
		if (type == 1)
			return getDvarInt("scr_zmod_semtex_ammo");
		else
			if (type == 2)
				return getDvarInt("scr_zmod_claymore_ammo");
			else
				if (type == 3)
					return getDvarInt("scr_zmod_c4_ammo");
	return 1;
}

monitorNades()
{
	self endon("disconnect");
	self endon("death");
	weap = self getNadeWeap();
	wname = level.nadenames[self.nadetype];
	confirm = true;
	for ( ; ; )
	{
		if (self.nades > 0 && !self hasWeapon("flare_mp") && confirm)
		{
				if (self getWeaponAmmoClip(weap) == 0)
				{
					if (weap == "c4_mp" && self.c4array.size > 0){
						wait 0.6;
						continue;
					}
					self GiveGrenade();
					self.nades--;
					confirm = false;
				}
		}
		if (!confirm && self hasWeapon(weap) && self getWeaponAmmoClip(weap) != 0)
				confirm = true;
		wait 0.6;
	}
}

GiveGrenade()
{
	type = self.nadetype;
	weap = self getNadeWeap();
	if (type == 0)
	{
			self SetOffhandPrimaryClass( "frag" );
			self _giveWeapon("frag_grenade_mp", 0);
			self setWeaponAmmoClip("frag_grenade_mp", 1);
	}
	else
		{
				self giveWeapon(weap);
				self setWeaponAmmoClip(weap, 1);
		}
}

giveThreadedItems()
{
	self endon("disconnect");
	self endon("death");
	self initTacticalInsertion();
	self initGrenade();
}

giveNonIntermissionPermissableItem()
{
	if (self.isZombie != 0)
		return;
	self thread giveThreadedItems();
}

initTacticalInsertion()
{
		if (!self.tact || self.lives <= 0)
			return false;
		self maps\mp\perks\_perkfunctions::setTacticalInsertion();
		return true;
}

giveNonIntermissionPermissableItems()
{
	foreach (player in level.players)
		player giveNonIntermissionPermissableItem();
}

initGrenade()
{
	if (self.isZombie != 0)
		return;
	self.nades = getDefaultNadeAmmo(self.nadetype);
	self thread monitorNades();
}

ibroadcast(msg)
{
	foreach (player in level.players)
		player iprintlnbold(msg);
}

ibroadcastTeam(msg, team)
{
	foreach (player in level.players)
		if (player.team == team)
			player iprintlnbold(msg);
}

ibroadcastDelay(time, msg, team)
{
	wait time;
	if (isDefined(team))
		ibroadcastTeam(msg, team);
	else
		ibroadcast(msg);
}

doPlaceMsgLoop()
{
	level endon("game_ended");
	for (;;)
	{
		if (level.msgtexttime > 0)
		{
			level.msgtexttime--;
			if (level.msgtexttime == 0){
				level.msgtext changeFontScaleOverTime(0.2);
				level.msgtext.fontScale = 6;
				level.msgtext fadeOverTime(0.2);
				level.msgtext.alpha = 0;
				if (isDefined(level.msgtexttitle))
				{
					level.msgtexttitle changeFontScaleOverTime(0.2);
					level.msgtexttitle.fontScale = 6;
					level.msgtexttitle fadeOverTime(0.2);
					level.msgtexttitle.alpha = 0;
				}
			}
		}
		wait 1;
	}
}



doPlaceMsgText(title, txt, time)
{
	level.msgtext destroy();
	level.msgtexttitle destroy();
	level.msgtext = level createServerFontString("objective");
	level.msgtext setPoint( "CENTER", "CENTER");
	
	level.msgtext setText(txt);
	level.msgtext.alpha = 0;
	level.msgtext.fontScale = 6;
	level.msgtext changeFontScaleOverTime(0.15);
	level.msgtext.fontScale = 1.3;
	level.msgtext fadeOverTime(0.15);
	level.msgtext.alpha = 1;
	
	
	if (isDefined(title))
	{
		level.msgtexttitle = level createServerFontString("objective");
		level.msgtexttitle setPoint( "CENTER", "CENTER");
		level.msgtexttitle.y = -30;
		level.msgtexttitle setText(title);
		level.msgtexttitle.alpha = 0;
		level.msgtexttitle.fontScale = 6;
		level.msgtexttitle changeFontScaleOverTime(0.15);
		level.msgtexttitle.fontScale = 2.5;
		level.msgtexttitle fadeOverTime(0.15);
		level.msgtexttitle.alpha = 1;
	}
	else
		level.msgtexttitle = undefined;
	
	level.msgtexttime = time;
}

doPlaceTimerText(txt)
{
	level.TimerText destroy();
	level.TimerText = level createServerFontString( "objective", 1.5 );
	level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
	if (isDefined(txt))
		level.TimerText setText(txt);
}

doPickZombie()
{
	doPlaceTimerText();
	
	times = 3;
	if (getDvarInt("scr_zmod_alpha_count") != 0)
		times = getDvarInt("scr_zmod_alpha_count");
	if (getDvarInt("scr_zmod_autoadjust") == 1)
	{
		if (level.players.size < 6)
			times = 2;
		if (level.players.size < 3)
			times = 1;
	}
	if (times >= level.players.size)
			times = level.players.size - 1;
	//If theres only one person, make sure they go zombie all the time
	if (times <= 0)
			times = 1;
	while (times > 0)
	{
		p = chooseZombie();
		if (p == -1)
			break;
		level.players[p].isZombie = 2;
		level.players[p] thread doAlphaZombie();
		times--;
	}
	level.TimerText setText("^1Alpha Zombies RELEASED!");
	
	level playSoundOnPlayers("mp_defeat");
	
	level.gameState = "playing"; 
	level notify("gamestatechange");
	level thread doPlaying();
	level thread doPlayingTimer();
	level thread inGameConstants();
	level thread giveNonIntermissionPermissableItems();
}

doPlaying()
{
	wait getdvarInt("scr_zmod_round_gap");
	level.TimerText destroy();
	while(1)
	{
		level.playersLeft = maps\mp\gametypes\_teams::CountPlayers();
		if(level.lastAlive == 0)
		{
			if(level.playersLeft["allies"] == 1)
			{
				level.lastAlive = 1;
				foreach(player in level.players)
				{
					if(player.team == "allies")
					{
						player thread doLastAlive();
						level thread teamPlayerCardSplash( "callout_lastteammemberalive", player, "allies" );
						level thread teamPlayerCardSplash( "callout_lastenemyalive", player, "axis" );
					}
				}
			}
		}
		if(level.playersLeft["allies"] == 0 || level.playersLeft["axis"] == 0)
		{
			level thread doEnding();
			return;
		}
		wait .5;
	}
}

doPlayingTimer()
{
	level.minutes = 0;
	level.seconds = 0;
	while(1)
	{
		wait 1;
		level.seconds++;
		if(level.seconds == 60)
		{
			level.minutes++;
			level.seconds = 0;
		}
		if(level.gameState == "ending")
		{
			return;
		}
	}
}

doEnding()
{
	level.gameState = "ending";
	level notify("gamestatechange");
	notifyEnding = spawnstruct();
	notifyEnding.titleText = "Round Over!";
	notifyEnding.notifyText2 = "Next Round Will Start Soon!";
	notifyEnding.glowColor = (0.0, 0.6, 0.3);
	
	wait 1;
	VisionSetNaked("blacktest", 1);
	
	calculateCredits();
	
	foreach(player in level.players)
	{
		player _clearPerks();
		player freezeControls(true);
		player thread maps\mp\gametypes\_hud_message::notifyMessage( notifyEnding );
		player.newcomer = 0;
	}
	CleanupKillstreaks();
	wait 4.5;
	VisionSetNaked(getDvar( "mapname" ), 2);
	
	foreach(player in level.players)
	{
		player freezeControls(false);
	}
	level thread doIntermission();
}

inGameConstants()
{
	while(1)
	{
		foreach(player in level.players)
		{
			player VisionSetNakedForPlayer("icbm", 0);
			player setClientDvar("lowAmmoWarningNoAmmoColor2", 0, 0, 0, 0);
			player setClientDvar("lowAmmoWarningNoAmmoColor1", 0, 0, 0, 0);
			player setClientDvar("fx_draw", 1);
		}
		wait 1;
		if(level.gameState == "ending")
		{
			return;
		}
	}
}
doMenuScroll()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		if(self.buttonPressed[ "+actionslot 3" ] == 1)
		{
			self.buttonPressed[ "+actionslot 3" ] = 0;
			self.menu--;
			if(self.menu < 0)
			{
				if(self.team == "allies")
				{
					self.menu = level.humanM.size-1;
					if (self.creditshop == true)
						self.menu = level.creditM.size - 1;
				}
				else
					{
						self.menu = level.zombieM.size-1;
					}
			}
			self notify("MENUCHANGE");
		}
		if(self.buttonPressed[ "+actionslot 1" ] == 1)
		{
			self.buttonPressed[ "+actionslot 1" ] = 0;
			self.menu++;
			if(self.team == "allies")
			{
				if(self.menu >= level.humanM.size)
				{
					self.menu = 0;
				}
				else
						if (self.creditshop == true)
							if(self.menu >= level.creditM.size)
								self.menu = 0;
			}
			else
				{
					if(self.menu >= level.zombieM.size)
					{
						self.menu = 0;
					}
				}
			self notify("MENUCHANGE");
		}
		self checkMenu();
		wait .045;
	}
}

checkMenu()
{
	if (self.team == "allies")
		if (self.creditshop)
		{
			if (self.menu >= level.creditM.size)
				self.menu = level.creditM.size - 1;
		}
		else
		{
			if (self.menu >= level.humanM.size)
				self.menu = level.humanM.size - 1;
		}
	else
		if (self.team == "axis")
			if (self.menu >= level.zombieM.size)
				self.menu = level.zombieM.size - 1;
}

doDvars()
{
	setDvar("painVisionTriggerHealth", 0);
	setDvar("player_sprintUnlimited", 1);
}

TR_HUD_LABEL_X = -5;
TR_HUD_VALUE_X = 48;
TR_HUD_VALUE_ALIGNX = "right";
TR_HUD_LABEL_ALIGNX = "right";

textPulseInit()
{
	self.baseFontScale = self.fontScale;
}

doTextPulse(type, scale)
{
	self thread textPulseThread(type, scale);
}

textPulseThread(type, scale)
{
	self notify("textpulse"+type);
	self endon("death");
	
	self ChangeFontScaleOverTime(0.05);
	if (isDefined(scale))
		self.fontScale *= scale;
	else
		self.fontScale *= 1.5;
	wait 0.1;
	self ChangeFontScaleOverTime(0.1);
	self.fontScale = self.baseFontScale;
}

doHealth()
{
	self endon("disconnect");
	self endon("death");
	self.curhealth = 0;
	self.healthtext = NewClientHudElem( self );
	self.healthtext.alignX = TR_HUD_VALUE_ALIGNX;
	self.healthtext.alignY = "top";
	self.healthtext.horzAlign = "right";
	self.healthtext.vertAlign = "top";
	self.healthtext.y = -25;
	self.healthtext.x = TR_HUD_VALUE_X;
	self.healthtext.foreground = true;
	self.healthtext.fontScale = 0.75;
	self.healthtext.font = "hudbig";
	self.healthtext.alpha = 1;
	self.healthtext.glow = 1;
	self.healthtext.glowColor = ( 2.55, 0, 0 );
	self.healthtext.glowAlpha = 1;
	self.healthtext.color = ( 1.0, 1.0, 1.0 );
	
	
	self.healthlabel = NewClientHudElem( self );
	self.healthlabel.alignX = TR_HUD_LABEL_ALIGNX;
	self.healthlabel.alignY = "top";
	self.healthlabel.horzAlign = "right";
	self.healthlabel.vertAlign = "top";
	self.healthlabel.y = -25;
	self.healthlabel.x = TR_HUD_LABEL_X;
	self.healthlabel.foreground = true;
	self.healthlabel.fontScale = 0.75;
	self.healthlabel.font = "hudbig";
	self.healthlabel.alpha = 1;
	self.healthlabel.glow = 1;
	self.healthlabel.glowColor = ( 2.55, 0, 0 );
	self.healthlabel.glowAlpha = 1;
	self.healthlabel.color = ( 1.0, 1.0, 1.0 );
	self.healthlabel setText("Max HP: ");
	
	self.healthlabel textPulseInit();
	self.healthtext textPulseInit();
	
	while(1)
	{
		self.healthtext setValue(self.maxhealth);
		self waittill("HEALTH");
	}
}

doCash()
{
	self endon("disconnect");
	self endon("death");
	self.cashlabel = NewClientHudElem( self );
	
	self.cashlabel.alignX = TR_HUD_LABEL_ALIGNX;
	self.cashlabel.alignY = "top";
	self.cashlabel.horzAlign = "right";
	self.cashlabel.vertAlign = "top";
	self.cashlabel.foreground = true;
	self.cashlabel.y = -10;
	self.cashlabel.x = TR_HUD_LABEL_X;
	self.cashlabel.fontScale = 0.75;
	self.cashlabel.font = "hudbig";
	self.cashlabel.alpha = 1;
	self.cashlabel.glow = 1;
	self.cashlabel.glowAlpha = 1;
	self.cashlabel.color = ( 1.0, 1.0, 1.0 );
	self.cashlabel setText("Cash: ");
	
	self.cash = NewClientHudElem( self );
	self.cash.alignX = TR_HUD_VALUE_ALIGNX;
	self.cash.alignY = "top";
	self.cash.horzAlign = "right";
	self.cash.vertAlign = "top";
	self.cash.foreground = true;
	self.cash.y = -10;
	self.cash.x = TR_HUD_VALUE_X;
	self.cash.fontScale = 0.75;
	self.cash.font = "hudbig";
	self.cash.alpha = 1;
	self.cash.glow = 1;
	self.cash.glowAlpha = 1;
	self.cash.color = ( 1.0, 1.0, 1.0 );
	
	self.cash textPulseInit();
	self.cashlabel textPulseInit();
	
	while(1)
	{		
		if (self.creditshop == false)
		{
			self.cashlabel.glowColor = ( 0, 1, 0 );
			self.cash.glowColor = ( 0, 1, 0 );
			self.cashlabel setText("Cash: ");
			self.cash setValue(self.bounty);
		}
		else
			{
				self.cashlabel.glowColor = ( 0, 0, 1 );
				self.cash.glowColor = ( 0, 0, 1 );
				self.cashlabel setText("Credits: ");
				self.cash setValue(self.credits);
			}
		self waittill("CASH");
	}
}

doLives()
{
	self endon("disconnect");
	self endon("death");
	curlives = -1;
	
	self.lifetext = NewClientHudElem( self );
	self.lifetext.alignX = TR_HUD_VALUE_ALIGNX;
	self.lifetext.alignY = "top";
	self.lifetext.horzAlign = "right";
	self.lifetext.vertAlign = "top";
	self.lifetext.y = 5;
	self.lifetext.x = TR_HUD_VALUE_X;
	self.lifetext.foreground = true;
	self.lifetext.fontScale = 0.75;
	self.lifetext.font = "hudbig";
	self.lifetext.alpha = 1;
	self.lifetext.glow = 1;
	self.lifetext.glowColor = ( 0.45, 0.45, 1 );
	self.lifetext.glowAlpha = 1;
	self.lifetext.color = ( 1.0, 1.0, 1.0 );
	
	self.lifelabel = NewClientHudElem( self );
	self.lifelabel.alignX = TR_HUD_LABEL_ALIGNX;
	self.lifelabel.alignY = "top";
	self.lifelabel.horzAlign = "right";
	self.lifelabel.vertAlign = "top";
	self.lifelabel.y = 5;
	self.lifelabel.x = TR_HUD_LABEL_X;
	self.lifelabel.foreground = true;
	self.lifelabel.fontScale = 0.75;
	self.lifelabel.font = "hudbig";
	self.lifelabel.alpha = 1;
	self.lifelabel.glow = 1;
	self.lifelabel.glowColor = ( 0.45, 0.45, 1 );
	self.lifelabel.glowAlpha = 1;
	self.lifelabel.color = ( 1.0, 1.0, 1.0 );
	self.lifelabel setText("Lives: ");
	
	self.lifetext textPulseInit();
	self.lifelabel textPulseInit();
	
	while(1)
	{
		if(self.lives != curlives)
		{
			curlives = self.lives;
			self.lifetext setValue(self.lives);
		}
		self waittill("LIVES");
	}
}

statCashAdd(amount)
{
	if (self.bounty + amount < 99999)
		self.bounty += amount;
	else
		self.bounty = 99999;
	self notify("CASH");
	self.cash doTextPulse("cash");
}

statCashSub(amount)
{
	if (self.bounty - amount > 0)
		self.bounty -= amount;
	else
		self.bounty = 0;
	self notify("CASH");
	self.cash doTextPulse("cash", 0.6);
}

statCreditsAdd(amount)
{
	if (self.credits + amount < 99999)
		self.credits += amount;
	else
		self.credits = 99999;
	self notify("CASH");
}

statCreditsSub(amount)
{
	if (self.credits + amount > 0)
		self.credits -= amount;
	else
		self.credits = 0;
	self notify("CASH");
	
	self.cash doTextPulse("cash", 0.6);
}

statLivesInc(amount)
{
	if (self.lives < level.maxlives)
		self.lives++;
	self notify("LIVES");
	self.lifetext doTextPulse("life");
}

statLivesDec(amount)
{
	if (self.lives > 0)
		self.lives--;
	self notify("LIVES");
	self.lifetext doTextPulse("life", 0.6);
}

statMaxHealthAdd(amount)
{
	self.maxhp += amount;
	self.maxhealth = self.maxhp;
	self notify("HEALTH");
	self.healthtext doTextPulse("health");
}



HumanPerkHUDUpdate()
{
	switch(self.perkz["steadyaim"])
			{
				case 2:
					self.perkztext1 setText("Steady Aim: Pro");
					self.perkztext1.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext1 setText("Steady Aim: Activated");
					self.perkztext1.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext1 setText("Steady Aim: Not Activated");
					self.perkztext1.glowColor = ( 1, 0, 0 );
					break;
			}
			switch(self.perkz["sleightofhand"])
			{
				case 2:
					self.perkztext2 setText("Sleight of Hand: Pro");
					self.perkztext2.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext2 setText("Sleight of Hand: Activated");
					self.perkztext2.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext2 setText("Sleight of Hand: Not Activated");
					self.perkztext2.glowColor = ( 1, 0, 0 );
					break;
			}
			
			switch(self.perkz["stoppingpower"])
			{
				case 2:
					self.perkztext3 setText("Stopping Power: Pro");
					self.perkztext3.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext3 setText("Stopping Power: Activated");
					self.perkztext3.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext3 setText("Stopping Power: Not Activated");
					self.perkztext3.glowColor = ( 1, 0, 0 );
					break;
			}
			

			self.perkztext5 setText("Nuke Price: " + self.nuke_price);
			if (self.cheapnuke == true)
				self.perkztext5.glowColor = ( 0.4, 0.4, 1 );
			else
				self.perkztext5.glowColor = ( 1, 0, 0 );
			
			if (self.antialpha == false)
			{
					self.perkztext4 setText("Anti-Alpha: Not Activated");
					self.perkztext4.glowColor = ( 1, 0, 0 );
			}
			else
			{
					self.perkztext4 setText("Anti-Alpha: Activated");
					self.perkztext4.glowColor = ( 0, 1, 0 );
			}
}

ZombiePerkHUDUpdate()
{
			switch(self.perkz["coldblooded"])
			{
				case 2:
					self.perkztext1 setText("Cold Blooded: Pro");
					self.perkztext1.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext1 setText("Cold Blooded: Activated");
					self.perkztext1.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext1 setText("Cold Blooded: Not Activated");
					self.perkztext1.glowColor = ( 1, 0, 0 );
					break;
			}
			switch(self.perkz["ninja"])
			{
				case 2:
					self.perkztext2 setText("Ninja: Pro");
					self.perkztext2.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext2 setText("Ninja: Activated");
					self.perkztext2.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext2 setText("Ninja: Not Activated");
					self.perkztext2.glowColor = ( 1, 0, 0 );
					break;
			}
			switch(self.perkz["lightweight"])
			{
				case 2:
					self.perkztext3 setText("Lightweight: Pro");
					self.perkztext3.glowColor = ( 0, 1, 0 );
					break;
				case 1:
					self.perkztext3 setText("Lightweight: Activated");
					self.perkztext3.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext3 setText("Lightweight: Not Activated");
					self.perkztext3.glowColor = ( 1, 0, 0 );
					break;
			}
			switch(self.perkz["finalstand"])
			{
				case 2:
					self.perkztext4 setText("Final Stand: Activated");
					self.perkztext4.glowColor = ( 0, 1, 0 );
					break;
				default:
					self.perkztext4 setText("Final Stand: Not Activated");
					self.perkztext4.glowColor = ( 1, 0, 0 );
					break;
			}
			
			if (self.thermal == 1)
			{
				self.perkztext5 setText("Thermal Overlay: Activated");
				self.perkztext5.glowColor = ( 0, 1, 0 );
			}
			else
			{
				self.perkztext5 setText("Thermal Overlay: Not Activated");
				self.perkztext5.glowColor = ( 1, 0, 0 );
			}
}

HUDupdate()
{
		if(self.team == "allies")
		{
			self HumanPerkHUDUpdate();
			//Human menu
			if (self.creditshop == false)
			{
				if((self.menu == 1) || (self.menu == 2))
				{
					current = self getCurrentWeapon();
					if(self.menu == 1)
						{
							if(self.attach["akimbo"] == 1)
								{
									self.option1 setText("Press [{+smoke}] - " + level.humanM[self.menu][0]);
								}
							else
								{
									self.option1 setText("Upgrade Unavailable");
								}
							if(self.attach["fmj"] == 1)
							{
								self.option2 setText("Press [{+actionslot 2}] - " + level.humanM[self.menu][1]);
							}
							else
								{
									self.option2 setText("Upgrade Unavailable");
								}
						if((self.attach["eotech"] == 1 && self.eotech == true) || (self.attach["reddot"] == 1 && self.eotech == false))
							{
								if (!self.eotech)
									self.option3 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][2]["normal"]);
								else
									self.option3 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][2]["new"]);
							}
						else
							{
								self.option3 setText("Upgrade Unavailable");
							}
						}
						if(self.menu == 2)
						{
							if(self.attach["silencer"] == 1)
							{
								self.option1 setText("Press [{+smoke}] - " + level.humanM[self.menu][0]);
							}
						else
							{
								self.option1 setText("Upgrade Unavailable");
							}
						if(self.attach["xmags"] == 1)
						{
							self.option2 setText("Press [{+actionslot 2}] - " + level.humanM[self.menu][1]);
						}
						else
								{
									self.option2 setText("Upgrade Unavailable");
								}
						if(self.attach["rof"] == 1)
						{
							self.option3 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][2]);
						}
						else
							{
								self.option3 setText("Upgrade Unavailable");
							}
						}
				}
				else
					if(self.menu == 3 || self.menu == 4)
					{
						if(self.menu == 3)
						{
							switch(self.perkz["steadyaim"])
							{
								case 0:
									self.option1 setText("Press [{+smoke}] - " + level.humanM[self.menu][0]["normal"]);
									break;
								case 1:
									self.option1 setText("Press [{+smoke}] - " + level.humanM[self.menu][0]["pro"]);
									break;
								case 2:
								default:
									self.option1 setText("Perk can not be upgraded");
									break;
							}
							switch(self.perkz["sleightofhand"])
							{
								case 0:
									self.option2 setText("Press [{+actionslot 2}] - " + level.humanM[self.menu][1]["normal"]);
									break;
								case 1:
									self.option2 setText("Press [{+actionslot 2}] - " + level.humanM[self.menu][1]["pro"]);
									break;
								case 2:
								default:
									self.option2 setText("Perk can not be upgraded");
									break;
							}

							if (self.hasROFL == false)
								self.option3 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][2]["normal"]);
							else
								self.option3 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][2]["new"]);
						}
						if(self.menu == 4)
						{
								switch(self.perkz["stoppingpower"])
								{
									case 0:
										self.option1 setText("Press [{+smoke}] - " + level.humanM[self.menu][0]["normal"]);
										break;
									case 1:
										self.option1 setText("Press [{+smoke}] - " + level.humanM[self.menu][0]["pro"]);
										break;
									case 2:
									default:
										self.option1 setText("Perk can not be upgraded");
										break;
								}
								
								if (self.attach["acog"] == 1)
									self.option2 setText("Press [{+actionslot 2}] - " + level.humanM[self.menu][1]["normal"]);
								else
									self.option2 setText("Upgrade Unavailable");
								
								self.option3 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][2]);
						}
					}
					else
						{
							if (level.humanM[self.menu][0] != "")
							{
									if (self.menu != 5)
											self.option1 setText("Press [{+smoke}] - " + level.humanM[self.menu][0]);
									else
										self.option1 setText("Press [{+smoke}] - " + level.humanM[self.menu][0] + self.nuke_price);
							}
							else
								self.option1 setText("");
								
							if(self.menu != 0)
							{
								if (self.menu == 7)
								{
									if (self.rp <= 0)
										which1 = "buy";
									else
										if (self.isRepairing)
											which1 = "off";
										else
											which1 = "on";
									self.option2 setText("Press [{+actionslot 2}] - " + level.humanM[self.menu][1][which1]);
								}
								else
									if (level.humanM[self.menu][1] != "")
										self.option2 setText("Press [{+actionslot 2}] - " + level.humanM[self.menu][1]);
									else
										self.option2 setText("");
							}
							else
									self.option2 setText(level.humanM[self.menu][1][self.exTo]);
							if (self.menu == 7)
							{
								self.option3 setText("Press [{+actionslot 4}] - " + "This slot is not in use");
							}
							else
									self.option3 setText("Press [{+actionslot 4}] - " + level.humanM[self.menu][2]);
						}
			}
			else
				{
					txt1 = "Unavailable";
					txt2 = "Unavailable";
					txt3 = "Unavailable";
					av1 = true;
					av2 = true;
					av3 = true;
					switch (self.menu)
					{
						case 0:
							if (self.humancash)
								av1 = false;
							if (self.zombiecash)
								av2 = false;
							if (self.fullammo)
								av3 = false;
							break;
						case 1:
							if (self.atk >= 3)
								av1 = false;
							if (self.antialpha)
								av2 = false;
							if (self.lives >= level.maxlives)
								av3 = false;
							break;
						case 2:
							if (self.cheapnuke)
								av1 = false;
							if (self.commandopro)
								av2 = false;
							if (self.hasROFL)
								av3 = false;
							break;
						case 3:
							if (self.eotech)
								av1 = false;
							if (self.nadetype >= level.nadetypes.size - 1)
								av2 = false;
							if (self.humanfs)
								av3 = false;
							break;
						case 4:
							if (self.tact)
								av1 = false;
							if (self.riotz)
								av2 = false;
						break;
					}
					if (av1)
						txt1 = "Press [{+smoke}] - " + level.creditM[self.menu][0]["text"];
					if (av2)
						if (self.menu != 3)
							txt2 = "Press [{+actionslot 2}] - " + level.creditM[self.menu][1]["text"];
						else
							txt2 = "Press [{+actionslot 2}] - " + level.creditM[self.menu][1]["text"][self.nadetype];
					if (av3)
						txt3 = "Press [{+actionslot 4}] - " + level.creditM[self.menu][2]["text"];
					self.option1 setText(txt1);
					self.option2 setText(txt2);
					self.option3 setText(txt3);
				}
			
		}
		if(self.team == "axis")
		{
			self ZombiePerkHUDUpdate();
			if(self.menu == 1 || self.menu == 2 || self.menu == 3)
			{
				if(self.menu == 1)
				{
					switch(self.perkz["coldblooded"])
					{
						case 0:
							self.option1 setText("Press [{+smoke}] - " + level.zombieM[self.menu][0]["normal"]);
							break;
						case 1:
							self.option1 setText("Press [{+smoke}] - " + level.zombieM[self.menu][0]["pro"]);
							break;
						case 2:
							default:self.option1 setText("Perk can not be upgraded");
							break;
					}
					switch(self.perkz["ninja"])
					{
						case 0:
							self.option2 setText("Press [{+actionslot 2}] - " + level.zombieM[self.menu][1]["normal"]);
							break;
						case 1:
							self.option2 setText("Press [{+actionslot 2}] - " + level.zombieM[self.menu][1]["pro"]);
							break;
						case 2:
						default:
							self.option2 setText("Perk can not be upgraded");
							break;
					}
					switch(self.perkz["lightweight"])
					{
						case 0:
							self.option3 setText("Press [{+actionslot 4}] - " + level.zombieM[self.menu][2]["normal"]);
							break;
						case 1:
							self.option3 setText("Press [{+actionslot 4}] - " + level.zombieM[self.menu][2]["pro"]);
							break;
						case 2:
							default:self.option3 setText("Perk can not be upgraded");
							break;
					}
				}
				else
					if(self.menu == 2)
					{
						switch(self.perkz["finalstand"])
						{
							case 0:
								self.option1 setText("Press [{+smoke}] - " + level.zombieM[self.menu][0]["normal"]);
								break;
							case 1:
							case 2:
							default:
								self.option1 setText("Perk can not be upgraded");
								break;
						}
						if (level.zombieM[self.menu][1] != "")
							self.option2 setText("Press [{+actionslot 2}] - " + level.zombieM[self.menu][1]);
						else
							self.option2 setText("");
						
						self.option3 setText("Press [{+actionslot 4}] - " + level.zombieM[self.menu][2]);

					}
					else
						if (self.menu == 3)
						{
							if (!self.blastshield)
								self.option1 setText("Press [{+smoke}] - " + level.zombieM[self.menu][0]);
							else
								self.option1 setText("Press [{+smoke}] - Equip/Unequip Blastshield");
							if (self.riotz)
								if (self hasWeapon("riotshield_mp"))
									self.option2 setText("Unavailable");
								else
									self.option2 setText("Press [{+actionslot 2}] - " + level.zombieM[self.menu][1]);
							else
								self.option2 setText("[Locked]");
								
							if (level.zombieM[self.menu][2] != "")
								self.option3 setText("Press [{+actionslot 4}] - " + level.zombieM[self.menu][2]);
							else
								self.option3 setText("");
						}
			}
			else
				{
					self.option1 setText("Press [{+smoke}] - " + level.zombieM[self.menu][0]);
					self.option2 setText("Press [{+actionslot 2}] - " + level.zombieM[self.menu][1]);
					self.option3 setText("Press [{+actionslot 4}] - " + level.zombieM[self.menu][2]);
				}
		}
}

doHUDControl_old()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		self.HintText setText(self.hint);
		self.hint = "";
		self HUDupdate();
		wait 1;
	}
}

doHUDControl()
{
	self endon("disconnect");
	self endon("death");
	self thread doHUDControl_old();
	while(1)
	{
		self.HintText setText(self.hint);
		self.hint = "";
		self HUDupdate();
		self waittill("MENUCHANGE_2");
	}
}

doServerHUDControl()
{
	level.infotext setText(getDvar("scr_zmod_infotext"));
}

doInfoScroll()
{
	self endon("disconnect");
	for(i = 1200;i >= -1200;i -= 4)
	{
		level.infotext.x = i;
		if(i <= -1200)
		{
			i = 1200;
		}
		wait .01;
	}
}

doScoreReset()
{
	self.savedStat["score"] += self.pers["score"];
	self.pers["score"] = 0;
	if (!self.ack["used_life"] || level.gameState != "playing")
	{
		self.savedStat["kills"] += self.pers["kills"];
		self.pers["kills"] = 0;
		self.kills = 0;
	}
	self.savedStat["assists"] += self.pers["assists"];
	self.pers["assists"] = 0;
	self.savedStat["deaths"] += self.pers["deaths"];
	self.pers["deaths"] = 0;
	self.pers["suicides"] = 0;
	self.score = 0;
	
	self.assists = 0;
	self.deaths = 0;
	self.suicides = 0;
}

doPerksSetup()
{
	self.perkz = [];
	self.perkz["steadyaim"] = 0;
	self.perkz["stoppingpower"] = 0;
	self.perkz["sitrep"] = 0;
	self.perkz["sleightofhand"] = 0;
	self.perkz["coldblooded"] = 0;
	self.perkz["ninja"] = 0;
	self.perkz["lightweight"] = 0;
	self.perkz["finalstand"] = 0;
	self.perkz["blastshield"] = 0;
}

doSpawn()
{
	self.combo = 0;
	if (self.newcomer == 1)
	{
		self.ck = self.kills;
		self.cd = self.deaths;
		self.cs = self.suicides;
		self.newcomer = 0;
	}
	
	if(level.gameState == "playing" || level.gameState == "ending")
	{
		if(self.deaths > 0 && self.isZombie == 0 && self.team == "allies")
		{
			if (self.lives > 0)
			{
				self statLivesDec();
				self.ack["used_life"] = true;
				self iPrintLnBold("^2Used ^5a life!");
				if (level.playersLeft["allies"] == 1)
					level.lastAlive = 0;
			}
			else
				{
					self.isZombie = 1;
					self.credit_kills = self.kills;
				}
					
		}
		
		if(self.isZombie == 0)
		{
			self thread doSetup(true); //Called when human joins midround or respawn
		}
		
			if(self.isZombie == 1)
			{
				self thread doZombie();
			}
			if(self.isZombie == 2)
			{
				self thread doAlphaZombie();
			}
		
	}
	else
		{
			self thread doSetup(false); //Called when human joins on intermission
		}
	
	self thread doDvars();
	self.menu = 0;
	self thread CreatePlayerHUD();
	self thread doMenuScroll();
	self thread doHUDControl();
	self thread doCash();
	self thread doHealth();
	self thread doLives();
	self thread destroyOnDeath();
	self thread doMenuInfo();
	
	//Testing money on Player Spawn, +5000 | Testversion
	self statCashAdd(5000);
	
	if(level.gamestate == "starting")
	{
		self thread OMAExploitFix();
	}
	self freezeControlsWrapper( false );
	if (self.ack["safe"] == false)
		self.ack["safe"] = true;
}

doMenuInfo()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		if (self.team == "axis")
			self.menutext setText("Zombie Shop " + (self.menu+1) + "/" + (level.zombieM.size));
		else
			if (self.creditshop == true)
				self.menutext setText("Credit Shop " + (self.menu+1) + "/" + (level.creditM.size));
			else
				self.menutext setText("Human Shop " + (self.menu+1) + "/" + (level.humanM.size));
		self notify("MENUCHANGE_2");
		self waittill("MENUCHANGE");
	}
}

doJoinTeam()
{
	if(self.CONNECT == 1)
		{
			notifyHello = spawnstruct();
			notifyHello.titleText = "Welcome to the [UD]Ultimate Zombie Server";
			notifyHello.notifyText = "Please read rules at bottom!";
			notifyHello.notifyText2 = "Modified by Chaz & [UD]Funky ";
			notifyHello.glowColor = (0.0, 0.6, 0.3);
			if(level.gameState == "intermission" || level.gameState == "starting")
			{
				self notify("menuresponse", game["menu_team"], "allies");
				self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyHello );
			}
			if(level.gameState == "playing" || level.gameState == "ending"){
			self notify("menuresponse", game["menu_team"], "allies");
			}
		self.CONNECT = 0;
		}
}

ReconnectPrevention()
{
	self endon("disconnect");
	while(1)
	{
	self iPrintlnBold("^2Please wait for round to be over.");
	if(self.team != "spectator")
		{
			self notify("menuresponse", game["menu_team"], "spectator");
		}
	maps\mp\gametypes\_spectating::setSpectatePermissions();
	self allowSpectateTeam( "freelook", true );
	self.sessionstate = "spectator";
	self setContents( 0 );
	if(level.gameState == "intermission"){
		return;
	}
	wait 1;
	}
}

doInit()
{
	level.gameState = "";
	level.ShowCreditShop = false;
	level weaponInit();
	level CostInit();
	level MenuInit();
	level CreateServerHUD();
	level doServerHUDControl();
	level thread OverRider();
	level thread doChallenges();
	level thread doPlaceMsgLoop();
	CleanupKillstreaks();
	level.mapwait = 0;
	
	level thread maps\mp\gametypes\MapEdit::init();
	
	setDvar("g_gametype", "war");
	setDvar("ui_gametype", "war");
	setDvar("scr_war_scorelimit", 0);
	setDvar("scr_war_waverespawndelay", 0);
	setDvar("scr_war_playerrespawndelay", 0);
	wait 2;
	
	level thread doGameStarter();
	if(level.friendlyfire != 0)
	{
		level thread ffend();
	}
}

CostInit()
{
	level.itemCost = [];
	level.itemCost["ammo"] = 100;
	level.itemCost["LMG"] = 200;
	level.itemCost["Assault Rifle"] = 150;
	level.itemCost["Machine Pistol"] = 50;
	level.itemCost["Riot"] = 200;
	level.itemCost["Akimbo"] = 50;
	level.itemCost["Eotech"] = 50;
	level.itemCost["FMJ"] = 100;
	level.itemCost["Silencer"] = 200;
	level.itemCost["XMags"] = 150;
	level.itemCost["ROF"] = 50;
	level.itemCost["health"] = 50;
	level.itemCost["Thermal"] = 200;
	level.itemCost["ThrowingKnife"] = 300;
	level.itemCost["SteadyAim"] = 150;
	level.itemCost["SteadyAimPro"] = 100;
	level.itemCost["SleightOfHand"] = 150;
	level.itemCost["SleightOfHandPro"] = 100;
	level.itemCost["SitRep"] = 50;
	level.itemCost["SitRepPro"] = 50;
	level.itemCost["StoppingPower"] = 200;
	level.itemCost["StoppingPowerPro"] = 50;
	level.itemCost["ColdBlooded"] = 250;
	level.itemCost["ColdBloodedPro"] = 100;
	level.itemCost["Ninja"] = 100;
	level.itemCost["NinjaPro"] = 100;
	level.itemCost["Lightweight"] = 100;
	level.itemCost["LightweightPro"] = 50;
	level.itemCost["FinalStand"] = 100;
	level.itemCost["pmissile"] = 150;
	level.itemCost["rpg7"] = 50;
	level.itemCost["nuke"] = 3500;
	level.itemCost["nuke_cheap"] = 2500;
	level.itemCost["rifle"] = 100;
	level.itemCost["smg"] = 200;
	level.itemCost["stinger"] = 150;
	level.itemCost["ac130"] = 1000;
	level.itemCost["sentry"] = 450;
	level.itemCost["choppergunner"] = 800;
	level.itemCost["pavelow"] = 500;
	level.itemCost["acog"] = 50;
	level.itemCost["repair"] = 250;
	level.itemCost["harrier"] = 450;
	
	level.itemCost["artillery"] = 400;
	level.itemCost["airstrike"] = 250;
	level.itemCost["GrimReaper"] = 500;
	
	level.itemCost["blastshield"] = 300;
	level.itemCost["riotz"] = 100;
	
	
	level.itemCost["ch_cash"] = 400;
	level.itemCost["cz_cash"] = 400;
	level.itemCost["ch_fullammo"] = 250;
	level.itemCost["cz_atk"] = 350;
	level.itemCost["c_alpha"] = 450;
	level.itemCost["ch_life"] = 300;
	level.itemCost["ch_cheapnuke"] = 1500;
	level.itemCost["ch_commandopro"] = 250;
	level.itemCost["ch_rofl"] = 2000;
	level.itemCost["ch_eotech"] = 200;
	level.itemCost["ch_nadeupgrade"] = 200;
	level.itemCost["ch_finalstand"] = 600;
	level.itemCost["ch_tact"] = 250;
	level.itemCost["cz_riot"] = 800;
}

weaponInit()
{
	level.lmg = [];
	level.lmg[0] = "rpd";
	level.weapname["rpd"] = "RPD";
	level.lmg[1] = "sa80";
	level.weapname["sa80"] = "LSW";
	level.lmg[2] = "mg4";
	level.weapname["mg4"] = "MG4";
	level.lmg[3] = "m240";
	level.weapname["m240"] = "M240";
	level.lmg[4] = "aug";
	level.weapname["aug"] = "AUG";
	
	level.assault = [];
	level.assault[0] = "ak47";
	level.weapname["ak47"] = "AK-47";
	level.assault[1] = "m16";
	level.weapname["m16"] = "M16";
	level.assault[2] = "m4";
	level.weapname["m4"] = "M4";
	level.assault[3] = "fn2000";
	level.weapname["fn2000"] = "F2000";
	level.assault[4] = "masada";
	level.weapname["masada"] = "ACR";
	level.assault[5] = "famas";
	level.weapname["famas"] = "FAMAS";
	level.assault[6] = "fal";
	level.weapname["fal"] = "FAL";
	level.assault[7] = "scar";
	level.weapname["scar"] = "SCAR-H";
	level.assault[8] = "tavor";
	level.weapname["tavor"] = "TAR-21";
	
	level.smg = [];
	level.smg[0] = "mp5k";
	level.weapname["mp5k"] = "MP5K";
	level.smg[1] = "uzi";
	level.weapname["uzi"] = "MINI-UZI";
	level.smg[2] = "p90";
	level.weapname["p90"] = "P90";
	level.smg[3] = "kriss";
	level.weapname["kriss"] = "VECTOR";
	level.smg[4] = "ump45";
	level.weapname["ump45"] = "UMP45";
	
	level.shot = [];
	level.shot[0] = "ranger";
	level.weapname["ranger"] = "RANGER";
	level.shot[1] = "model1887";
	level.weapname["model1887"] = "MODEL-1887";
	level.shot[2] = "striker";
	level.weapname["striker"] = "STRIKER";
	level.shot[3] = "aa12";
	level.weapname["aa12"] = "AA12";
	level.shot[4] = "m1014";
	level.weapname["m1014"] = "M1014";
	level.shot[5] = "spas12";
	level.weapname["spas12"] = "SPAS-12";
	
	level.machine = [];
	level.machine[0] = "pp2000";
	level.weapname["pp2000"] = "PP2000";
	level.machine[1] = "glock";
	level.weapname["glock"] = "G18";
	level.machine[2] = "beretta393";
	level.weapname["beretta393"] = "RAFFICA";
	
	level.hand = [];
	level.hand[0] = "beretta";
	level.weapname["beretta"] = "M9";
	level.hand[1] = "usp";
	level.weapname["usp"] = "USP .45";
	level.hand[2] = "deserteagle";
	level.weapname["deserteagle"] = "D. EAGLE";
	level.hand[3] = "coltanaconda";
	level.weapname["coltanaconda"] = ".44 MAGNUM";
	
	level.rifle = [];
	level.rifle[0] = "wa2000";
	level.weapname["wa2000"] = "WA2000";
	level.rifle[1] = "barrett";
	level.weapname["barrett"] = "BARRETT .50CAL";
	level.rifle[2] = "cheytac";
	level.weapname["cheytac"] = "INTERVENTION";
	level.rifle[3] = "m21";
	level.weapname["m21"] = "M21 EBR";
	
	level.explosives = [];
	level.explosives[0] = "frag";
	level.weapname["frag"] = "FRAG";
	level.explosives[1] = "semtex";
	level.weapname["semtex"] = "SEMTEX";
	level.explosives[2] = "claymore";
	level.weapname["claymore"] = "CLAYMORE";
	level.explosives[3] = "c4";
	level.weapname["c4"] = "C4 CHARGE";
	
	level.weapname["riotshield"] = "Riotshield";
	
	level.weaponclasses = [];
	level.weaponclasses[0] = "weapon_lmg";
	level.weaponclasses[1] = "weapon_assault";
	level.weaponclasses[2] = "weapon_smg";
	level.weaponclasses[3] = "weapon_shotgun";
	level.weaponclasses[4] = "weapon_machine_pistol";
	level.weaponclasses[5] = "weapon_pistol";
	level.weaponclasses[6] = "weapon_sniper";
	level.weaponclasses[7] = "weapon_riot";
	level.weaponclasses[8] = "weapon_explosives";
}

MenuInit()
{
	level.humanM = [];
	level.zombieM = [];
	i = 0;
	level.humanM[i] = [];
	level.humanM[i][0] = "Buy Ammo for Current Weapon - " + level.itemCost["ammo"];
	level.humanM[i][1] = [];
	level.humanM[i][1]["LMG"] = "Press [{+actionslot 2}] - Exchange for a LMG - " + level.itemCost["LMG"];
	level.humanM[i][1]["Assault Rifle"] = "Press [{+actionslot 2}] - Exchange for an Assault Rifle - " + level.itemCost["Assault Rifle"];
	level.humanM[i][1]["Machine Pistol"] = "Press [{+actionslot 2}] - Exchange for a Machine Pistol - " + level.itemCost["Machine Pistol"];
	level.humanM[i][1]["smg"] = "Press [{+actionslot 2}] - Exchange for a SMG - " + level.itemCost["smg"];
	level.humanM[i][1]["Unavailable"] = "Weapon can not be Exchanged";
	level.humanM[i][2] = "Buy Riot Shield - " + level.itemCost["Riot"];
	i++;//Menu = 2
	level.humanM[i] = [];
	level.humanM[i][0] = "Upgrade to Akimbo - " + level.itemCost["Akimbo"];
	level.humanM[i][1] = "Upgrade to FMJ - " + level.itemCost["FMJ"];
	level.humanM[i][2]["new"] = "Upgrade to Holographic Sight - " + level.itemCost["Eotech"];
	level.humanM[i][2]["normal"] = "Upgrade to Red-Dot Sight - " + level.itemCost["Eotech"];
	i++;//Menu = 3
	level.humanM[i] = [];
	level.humanM[i][0] = "Upgrade to Silencer - " + level.itemCost["Silencer"];
	level.humanM[i][1] = "Upgrade to Extended Mags - " + level.itemCost["XMags"];
	level.humanM[i][2] = "Upgrade to Rapid Fire - " + level.itemCost["ROF"];
	i++;//Menu = 4
	level.humanM[i] = [];
	level.humanM[i][0]["normal"] = "Buy Steady Aim - " + level.itemCost["SteadyAim"];
	level.humanM[i][0]["pro"] = "Upgrade to Steady Aim Pro - " + level.itemCost["SteadyAimPro"];
	level.humanM[i][1]["normal"] = "Buy Sleight of Hand - " + level.itemCost["SleightOfHand"];
	level.humanM[i][1]["pro"] = "Upgrade to Sleight of Hand Pro - " + level.itemCost["SleightOfHandPro"];

	level.humanM[i][2]["normal"] = "Buy RPG-7 - " + level.itemCost["rpg7"];
	level.humanM[i][2]["new"] = "Buy ROFL Launcher -" + level.itemCost["rpg7"];
	i++;//Menu = 5
	level.humanM[i] = [];
	level.humanM[i][0]["normal"] = "Buy Stopping Power - " + level.itemCost["StoppingPower"];
	level.humanM[i][0]["pro"] = "Upgrade to Stopping Power Pro - " + level.itemCost["StoppingPowerPro"];
	level.humanM[i][1]["normal"] = "Buy ACOG Scope - " + level.itemCost["acog"];
	level.humanM[i][2] = "Buy Predator Strike - " + level.itemCost["pmissile"];
	i++;//Menu = 6
	level.humanM[i][0] = "Buy Tactical Nuke - ";
	level.humanM[i][1] = "Buy Sniper Rifle - " + level.itemCost["rifle"];
	level.humanM[i][2] = "Buy AC-130 - " + level.itemCost["ac130"];
	i++;//Menu = 7
	level.humanM[i][0] = "Buy Sentry - " + level.itemCost["sentry"];
	level.humanM[i][1] = "Buy Pave Low - " + level.itemCost["pavelow"];
	level.humanM[i][2] = "Buy Chopper Gunner - " + level.itemCost["choppergunner"];
	i++;//Menu = 8
	level.humanM[i][1]["buy"] = "Buy Door Repair Tool - " + level.itemCost["repair"];
	level.humanM[i][1]["on"] = "Switch to repair tool";
	level.humanM[i][1]["off"] = "Switch to weapons";
	level.humanM[i][0] = "Buy Harrier - " + level.itemCost["harrier"];
	level.humanM[i][2] = "";
	i++;//Menu = 9
	level.humanM[i][0] = "Buy Artillery - " + level.itemCost["artillery"];
	level.humanM[i][1] = "Buy Airstrike - " + level.itemcost ["airstrike"];
	level.humanM[i][2] = "Buy 8-Shot - " + level.itemCost["GrimReaper"];
	
	i = 0;
	level.zombieM[i] = [];
	level.zombieM[i][0] = "Buy Health - " + level.itemCost["health"];
	level.zombieM[i][1] = "Buy Thermal Overlay - " + level.itemCost["Thermal"];
	level.zombieM[i][2] = "Buy Throwing Knife - " + level.itemCost["ThrowingKnife"];
	i++;
	level.zombieM[i] = [];
	level.zombieM[i][0]["normal"] = "Buy Cold Blooded - " + level.itemCost["ColdBlooded"];
	level.zombieM[i][0]["pro"] = "Upgrade to Cold Blooded Pro - " + level.itemCost["ColdBloodedPro"];
	level.zombieM[i][1]["normal"] = "Buy Ninja - " + level.itemCost["Ninja"];
	level.zombieM[i][1]["pro"] = "Upgrade to Ninja Pro -" + level.itemCost["NinjaPro"];
	level.zombieM[i][2]["normal"] = "Buy Lightweight - " + level.itemCost["Lightweight"];
	level.zombieM[i][2]["pro"] = "Upgrade to Lightweight Pro - " + level.itemCost["LightweightPro"];
	i++;
	
	level.zombieM[i] = [];
	level.zombieM[i][0]["normal"] = "Buy Final Stand - " + level.itemCost["FinalStand"];
	level.zombieM[i][1] = "Buy Stinger - " + level.itemCost["stinger"];
	level.zombieM[i][2] = "Suicide";
	i++;
	level.zombieM[i][0] = "Buy Blast Shield - " + level.itemCost["blastshield"];
	level.zombieM[i][1] = "Buy Riot Shield - " + level.itemCost["riotz"]; 
	i = 0;
	level.creditM = [];
	
	level.creditM[i] = [];
	// i == 0
	level.creditM[i][0]["text"] = "[Human] Buy 200 Starting Cash - " + level.itemCost["ch_cash"];
	level.creditM[i][0]["cost"] = level.itemCost["ch_cash"];
	level.creditM[i][1]["text"] = "[Alpha Zombie Only] Buy 200 Starting Cash - " + level.itemCost["cz_cash"];
	level.creditM[i][1]["cost"] = level.itemCost["cz_cash"];
	level.creditM[i][2]["text"] = "[Human] Buy Full Ammo on Weapon Upgrade - " + level.itemCost["ch_fullammo"];
	level.creditM[i][2]["cost"] = level.itemCost["ch_fullammo"];
	i++; //i == 1
	level.creditM[i][0]["text"] = "[Zombie] Buy Increase Door ATK - " + level.itemCost["cz_atk"];
	level.creditM[i][0]["cost"] = level.itemCost["cz_atk"];
	level.creditM[i][1]["text"] = "Buy Anti-Alpha - " + level.itemCost["c_alpha"];
	level.creditM[i][1]["cost"] = level.itemCost["c_alpha"];
	level.creditM[i][2]["text"] = "[Human] Buy Extra Life - " + level.itemCost["ch_life"];
	level.creditM[i][2]["cost"] = level.itemCost["ch_life"];
	i++; //i == 2
	level.creditM[i][0]["text"] = "[Human] Buy Cheaper Nuke (1500) - " + level.itemCost["ch_cheapnuke"];
	level.creditM[i][0]["cost"] = level.itemCost["ch_cheapnuke"];
	level.creditM[i][1]["text"] = "[Human] Buy Commando Pro for LPA - " + level.itemCost["ch_commandopro"];
	level.creditM[i][1]["cost"] = level.itemCost["ch_commandopro"];
	level.creditM[i][2]["text"] = "[Human Shop] Unlock ROFL Launcher - " + level.itemCost["ch_rofl"];
	level.creditM[i][2]["cost"] = level.itemCost["ch_rofl"];
	i++; //i == 3
	level.creditM[i][0]["text"] = "[Human Shop] Unlock Holographic Sight - " + level.itemCost["ch_eotech"];
	level.creditM[i][0]["cost"] = level.itemCost["ch_eotech"];
	level.creditM[i][1]["text"] = [];
	level.creditM[i][1]["text"][0] = "[Human] Upgrade to Semtex - " + level.itemCost["ch_nadeupgrade"];
	level.creditM[i][1]["text"][1] = "[Human] Upgrade to Claymore - " + level.itemCost["ch_nadeupgrade"];
	level.creditM[i][1]["text"][2] = "[Human] Upgrade to C4 - " + level.itemCost["ch_nadeupgrade"];
	level.creditM[i][1]["cost"] = level.itemCost["ch_nadeupgrade"];
	level.creditM[i][2]["text"] = "[Human] Unlock Final Stand - " + level.itemCost["ch_finalstand"];
	level.creditM[i][2]["cost"] = level.itemCost["ch_finalstand"];
	i++; // i == 4
	level.creditM[i][0]["text"] = "[Human] Tactical Insertion for Lives - " + level.itemCost["ch_tact"];
	level.creditM[i][0]["cost"] = level.itemCost["ch_tact"];
	level.creditM[i][1]["text"] = "[Zombie] Unlock Riot Shield - " + level.itemCost["cz_riot"];
	level.creditM[i][1]["cost"] = level.itemCost["cz_riot"];
	
}

createFog()
{
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	level._effect[ "FOW" ] = loadfx( "dust/nuke_aftermath_mp" );
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 0 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , 3000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 0 , -3000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 3000 , 0 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 3000 , 3000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( 3000 , -3000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -3000 , 0 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -3000 , 3000 , 500 ));
	PlayFX(level._effect[ "FOW" ], level.mapCenter + ( -3000 , -3000 , 500 ));
}

OverRider()
{
	for(;;)
	{
		level notify("abort_forfeit");
		level.prematchPeriod = 0;
		
		if (level.enablekillcam)
			level.killcam = 1;
		else
			level.killcam = 0;
		level.killstreakRewards = 0;
		wait 1;
	}
}

ffend()
{
	level endon ( "game_ended" );
	for(i = 10;i > 0;i--)
	{
		foreach(player in level.players)
		{
			player iPrintlnBold("^1ERROR: Friendly Fires is Enabled. Game Ending");
		}
		wait .5;
	}
	exitLevel( false );
}

headend()
{
	level endon ( "game_ended" );
	for(i = 10;i > 0;i--)
	{
		foreach(player in level.players)
		{
			player iPrintlnBold("^1ERROR: Headshots Only is Enabled. Game Ending");
		}
		wait .5;
	}
	exitLevel( false );
}

destroyOnDeath()
{
	self endon("disconnect");
	self waittill ( "death" );
	self.HintText destroy();
	self.healthtext destroy();
	self.healthlabel destroy();
	self.lifetext destroy();
	self.lifelabel destroy();
	self.menutext destroy();
	self.cash destroy();
	self.cashlabel destroy();
	self.option1 destroy();
	self.option2 destroy();
	self.option3 destroy();
	self.scrollleft destroy();
	self.scrollright destroy();
	self.perkztext1 destroy();
	self.perkztext2 destroy();
	self.perkztext3 destroy();
	self.perkztext4 destroy();
	self.perkztext5 destroy();
}

OMAExploitFix()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		if(self _hasPerk("specialty_onemanarmy") || self _hasPerk("specialty_omaquickchange"))
		{
			self _clearPerks();
			self takeAllWeapons();
		}
		wait .5;
	}
}

CashFix()
{
	self endon("disconnect");
	while(1)
	{
		if(self.bounty < 0)
		{
			self.bounty = 0;
			self notify("CASH");
		}
		wait .5;
	}
}

iniButtons()
{
	self.buttonAction = [];
	self.buttonAction[0]="+actionslot 2";
	self.buttonAction[1]="+actionslot 1";
	self.buttonAction[2]="+actionslot 4";
	self.buttonAction[3]="+smoke";
	self.buttonAction[4]="+activate";
	self.buttonAction[5]="+frag";
	self.buttonAction[6]="+actionslot 3";
	self.buttonPressed = [];
	for(i=0;i<self.buttonAction.size;i++)
	{
		self.buttonPressed[self.buttonAction[i]] = 0;
		self thread monitorButtons( self.buttonAction[i] );
	}
}

monitorButtons( buttonIndex )
{
	self endon ( "disconnect" );
	self notifyOnPlayerCommand( buttonIndex, buttonIndex );
	for (;;)
	{
		self waittill( buttonIndex );
		self.buttonPressed[ buttonIndex ] = 1;
		wait .1;
		self.buttonPressed[ buttonIndex ] = 0;
	}
}

fadeOutMenu(dest)
{
	self.menutext fadeOverTime(0.3);
	self.menutext.alpha = 0.2;
	self.option1 fadeOverTime(0.3);
	self.option1.alpha = 0.2;
	self.option2 fadeOverTime(0.3);
	self.option2.alpha = 0.2;
	self.option3 fadeOverTime(0.3);
	self.option3.alpha = 0.2;
	self.option1 fadeOverTime(0.3);
	self.option1.alpha = 0.2;
	self.scrollleft fadeOverTime(0.3);
	self.scrollleft.alpha = 0.1;
	self.scrollright fadeOverTime(0.3);
	self.scrollright.alpha = 0.1;
}

fadeInMenu(dest)
{
	self.menutext fadeOverTime(0.3);
	self.menutext.alpha = 1;
	self.option1 fadeOverTime(0.3);
	self.option1.alpha = 1;
	self.option2 fadeOverTime(0.3);
	self.option2.alpha = 1;
	self.option3 fadeOverTime(0.3);
	self.option3.alpha = 1;
	self.option1 fadeOverTime(0.3);
	self.option1.alpha = 1;
	self.scrollleft fadeOverTime(0.3);
	self.scrollleft.alpha = 1;
	self.scrollright fadeOverTime(0.3);
	self.scrollright.alpha = 1;
}

CreatePlayerHUD()
{
	self.HintText = self createFontString( "objective", 1.25 );
	self.HintText setPoint( "CENTER", "CENTER", 0, 50 );
	

	b = -65;
	s = 15;
	i = 0;
	a = 0.85;
	
	self.scrollleft = NewClientHudElem( self );
	self.scrollleft.alignX = "center";
	self.scrollleft.alignY = "bottom";
	self.scrollleft.horzAlign = "center";
	self.scrollleft.vertAlign = "bottom";
	self.scrollleft.x = -230;
	self.scrollleft.y = -30;
	self.scrollleft.fontScale = 1;
	self.scrollleft.font = "hudbig";
	self.scrollleft.alpha = a;
	self.scrollleft.glow = 1;
	self.scrollleft.glowColor = ( 0, 0, 1 );
	self.scrollleft.glowAlpha = 1;
	self.scrollleft.color = ( 1.0, 1.0, 1.0 );
	
	self.scrollright = NewClientHudElem( self );
	self.scrollright.alignX = "center";
	self.scrollright.alignY = "bottom";
	self.scrollright.horzAlign = "center";
	self.scrollright.vertAlign = "bottom";
	self.scrollright.fontScale = 1.15;
	self.scrollright.x = 230;
	self.scrollright.y = -30;
	self.scrollright.fontScale = 1;
	self.scrollright.font = "hudbig";
	self.scrollright.alpha = a;
	self.scrollright.glow = 1;
	self.scrollright.glowColor = ( 0, 0, 1 );
	self.scrollright.glowAlpha = 1;
	self.scrollright.color = ( 1.0, 1.0, 1.0 );
	
	self.scrollright setText(">");
	self.scrollleft setText("<");
	
	self.menutext = NewClientHudElem( self );
	self.menutext.alignX = "center";
	self.menutext.alignY = "bottom";
	self.menutext.horzAlign = "center";
	self.menutext.vertAlign = "bottom";
	self.menutext.y = b + (s * i);
	self.menutext.foreground = true;
	self.menutext.fontScale = 1.15;
	self.menutext.font = "objective";
	self.menutext.alpha = a;
	self.menutext.glow = 1;
	self.menutext.glowColor = ( 0.2, 0.2, 1 );
	self.menutext.glowAlpha = 1;
	self.menutext.color = ( 1.0, 1.0, 1.0 );
	i++;
	
	self.option1 = NewClientHudElem( self );
	self.option1.alignX = "center";
	self.option1.alignY = "bottom";
	self.option1.horzAlign = "center";
	self.option1.vertAlign = "bottom";
	self.option1.y = b + (s * i);
	self.option1.foreground = true;
	self.option1.fontScale = 1.15;
	self.option1.font = "objective";
	self.option1.alpha = a;
	self.option1.glow = 1;
	self.option1.glowColor = ( 0, 0, 1 );
	self.option1.glowAlpha = 1;
	self.option1.color = ( 1.0, 1.0, 1.0 );
	i++;
	
	self.option2 = NewClientHudElem( self );
	self.option2.alignX = "center";
	self.option2.alignY = "bottom";
	self.option2.horzAlign = "center";
	self.option2.vertAlign = "bottom";
	self.option2.y = b + (s * i);
	self.option2.foreground = true;
	self.option2.fontScale = 1.15;
	self.option2.font = "objective";
	self.option2.alpha = a;
	self.option2.glow = 1;
	self.option2.glowColor = ( 0, 0, 1 );
	self.option2.glowAlpha = 1;
	self.option2.color = ( 1.0, 1.0, 1.0 );
	i++;
	
	self.option3 = NewClientHudElem( self );
	self.option3.alignX = "center";
	self.option3.alignY = "bottom";
	self.option3.horzAlign = "center";
	self.option3.vertAlign = "bottom";
	self.option3.y = b + (s * i);
	self.option3.foreground = true;
	self.option3.fontScale = 1.15;
	self.option3.font = "objective";
	self.option3.alpha = a;
	self.option3.glow = 1;
	self.option3.glowColor = ( 0, 0, 1 );
	self.option3.glowAlpha = 1;
	self.option3.color = ( 1.0, 1.0, 1.0 );
	i++;
	
	b = 50;
	s = 15;
	i = 0;
	x = 40;
	
	self.perkztext1 = NewClientHudElem( self );
	self.perkztext1.alignX = "right";
	self.perkztext1.alignY = "top";
	self.perkztext1.horzAlign = "right";
	self.perkztext1.vertAlign = "top";
	self.perkztext1.x = x;
	self.perkztext1.y = b + (s * i);
	self.perkztext1.foreground = true;
	self.perkztext1.fontScale = .45;
	self.perkztext1.font = "hudbig";
	self.perkztext1.alpha = a;
	self.perkztext1.glow = 1;
	self.perkztext1.glowColor = ( 1, 0, 0 );
	self.perkztext1.glowAlpha = 1;
	self.perkztext1.color = ( 1.0, 1.0, 1.0 );
	i++;
	self.perkztext2 = NewClientHudElem( self );
	self.perkztext2.alignX = "right";
	self.perkztext2.alignY = "top";
	self.perkztext2.horzAlign = "right";
	self.perkztext2.vertAlign = "top";
	self.perkztext2.x = x;
	self.perkztext2.y = b + (s * i);
	self.perkztext2.foreground = true;
	self.perkztext2.fontScale = .45;
	self.perkztext2.font = "hudbig";
	self.perkztext2.alpha = a;
	self.perkztext2.glow = 1;
	self.perkztext2.glowColor = ( 1, 0, 0 );
	self.perkztext2.glowAlpha = 1;
	self.perkztext2.color = ( 1.0, 1.0, 1.0 );
	self.perkztext3 = NewClientHudElem( self );
	i++;
	self.perkztext3.alignX = "right";
	self.perkztext3.alignY = "top";
	self.perkztext3.horzAlign = "right";
	self.perkztext3.vertAlign = "top";
	self.perkztext3.x = x;
	self.perkztext3.y = b + (s * i);
	self.perkztext3.foreground = true;
	self.perkztext3.fontScale = .45;
	self.perkztext3.font = "hudbig";
	self.perkztext3.alpha = a;
	self.perkztext3.glow = 1;
	self.perkztext3.glowColor = ( 1, 0, 0 );
	self.perkztext3.glowAlpha = 1;
	self.perkztext3.color = ( 1.0, 1.0, 1.0 );
	i++;
	self.perkztext4 = NewClientHudElem( self );
	self.perkztext4.alignX = "right";
	self.perkztext4.alignY = "top";
	self.perkztext4.horzAlign = "right";
	self.perkztext4.vertAlign = "top";
	self.perkztext4.x = x;
	self.perkztext4.y = b + (s * i);
	self.perkztext4.foreground = true;
	self.perkztext4.fontScale = .45;
	self.perkztext4.font = "hudbig";
	self.perkztext4.alpha = a;
	self.perkztext4.glow = 1;
	self.perkztext4.glowColor = ( 1, 0, 0 );
	self.perkztext4.glowAlpha = 1;
	self.perkztext4.color = ( 1.0, 1.0, 1.0 );
	i++;
	self.perkztext5 = NewClientHudElem( self );
	self.perkztext5.alignX = "right";
	self.perkztext5.alignY = "top";
	self.perkztext5.horzAlign = "right";
	self.perkztext5.vertAlign = "top";
	self.perkztext5.x = x;
	self.perkztext5.y = b + (s * i);
	self.perkztext5.foreground = true;
	self.perkztext5.fontScale = .45;
	self.perkztext5.font = "hudbig";
	self.perkztext5.alpha = a;
	self.perkztext5.glow = 1;
	self.perkztext5.glowColor = ( 1, 0, 0 );
	self.perkztext5.glowAlpha = 1;
	self.perkztext5.color = ( 1.0, 1.0, 1.0 );
}

CreateServerHUD()
{
	
	level.infotext = NewHudElem();
	level.infotext.alignX = "center";
	level.infotext.alignY = "bottom";
	level.infotext.horzAlign = "center";
	level.infotext.vertAlign = "bottom";
	level.infotext.y = 25;
	level.infotext.foreground = true;
	level.infotext.fontScale = 1;
	level.infotext.font = "objective";
	level.infotext.alpha = 1;
	level.infotext.glow = 0;
	level.infotext.glowColor = ( 0, 0, 0 );
	level.infotext.glowAlpha = 1;
	level.infotext.color = ( 1.0, 1.0, 1.0 );
}

init()
{
	level.scoreInfo = [];
	level.xpScale = getDvarInt( "scr_xpscale" );
	level.rankTable = [];
	precacheShader("white");
	precacheString( &"RANK_PLAYER_WAS_PROMOTED_N" );
	precacheString( &"RANK_PLAYER_WAS_PROMOTED" );
	precacheString( &"RANK_PROMOTED" );
	precacheString( &"MP_PLUS" );
	precacheString( &"RANK_ROMANI" );
	precacheString( &"RANK_ROMANII" );
	precacheString( &"RANK_ROMANIII" );
	registerScoreInfo("zmod_credits", 0);
	if ( level.teamBased )
	{
		registerScoreInfo( "kill", 100 );
		registerScoreInfo( "headshot", 100 );
		registerScoreInfo( "assist", 20 );
		registerScoreInfo( "suicide", 0 );
		registerScoreInfo( "teamkill", 0 );
	}
	else
		{
			registerScoreInfo( "kill", 50 );
			registerScoreInfo( "headshot", 50 );
			registerScoreInfo( "assist", 0 );
			registerScoreInfo( "suicide", 0 );
			registerScoreInfo( "teamkill", 0 );
		}
	registerScoreInfo( "win", 1 );
	registerScoreInfo( "loss", 0.5 );
	registerScoreInfo( "tie", 0.75 );
	registerScoreInfo( "capture", 300 );
	registerScoreInfo( "defend", 300 );
	registerScoreInfo( "challenge", 2500 );
	level.maxRank = int(tableLookup( "mp/rankTable.csv", 0, "maxrank", 1 ));
	level.maxPrestige = int(tableLookup( "mp/rankIconTable.csv", 0, "maxprestige", 1 ));
	pId = 0;
	rId = 0;
	for ( pId = 0; pId <= level.maxPrestige; pId++ )
	{
		for ( rId = 0;rId <= level.maxRank;rId++ )
		{
			precacheShader( tableLookup( "mp/rankIconTable.csv", 0, rId, pId+1 ) );
		}
	}
	rankId = 0;
	rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	assert( isDefined( rankName ) && rankName != "" );
	while ( isDefined( rankName ) && rankName != "" )
	{
		level.rankTable[rankId][1] = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
		level.rankTable[rankId][2] = tableLookup( "mp/ranktable.csv", 0, rankId, 2 );
		level.rankTable[rankId][3] = tableLookup( "mp/ranktable.csv", 0, rankId, 3 );
		level.rankTable[rankId][7] = tableLookup( "mp/ranktable.csv", 0, rankId, 7 );
		precacheString( tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 ) );
		rankId++;
		rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	}
	maps\mp\gametypes\_missions::buildChallegeInfo();
	
	chaz_init();
	level thread patientZeroWaiter();
	level thread onPlayerConnect();
	level thread doInit();
	
}

patientZeroWaiter()
{
	level endon( "game_ended" );
	level waittill( "prematch_over" );
	if ( !matchMakingGame() )
	{
		if ( getDvar( "mapname" ) == "mp_rust" && randomInt( 1000 ) == 999 )
		{
			level.patientZeroName = level.players[0].name;
		}
	}
	else
		{
			if ( getDvar( "scr_patientZero" ) != "" )
			{
				level.patientZeroName = getDvar( "scr_patientZero" );
			}
		}
}

isRegisteredEvent( type )
{
	if ( isDefined( level.scoreInfo[type] ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

registerScoreInfo( type, value )
{
	level.scoreInfo[type]["value"] = value;
}

getScoreInfoValue( type )
{
	overrideDvar = "scr_" + level.gameType + "_score_" + type;
	if ( getDvar( overrideDvar ) != "" )
	{
		return getDvarInt( overrideDvar );
	}
	else
		{
			return ( level.scoreInfo[type]["value"] );
		}
}

getScoreInfoLabel( type )
{
	return ( level.scoreInfo[type]["label"] );
}

getRankInfoMinXP( rankId )
{
	return int(level.rankTable[rankId][2]);
}

getRankInfoXPAmt( rankId )
{
	return int(level.rankTable[rankId][3]);
}

getRankInfoMaxXp( rankId )
{
	return int(level.rankTable[rankId][7]);
}

getRankInfoFull( rankId )
{
	return tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 );
}

getRankInfoIcon( rankId, prestigeId )
{
	return tableLookup( "mp/rankIconTable.csv", 0, rankId, prestigeId+1 );
}

getRankInfoLevel( rankId )
{
	return int( tableLookup( "mp/ranktable.csv", 0, rankId, 13 ) );
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player.pers["rankxp"] = player maps\mp\gametypes\_persistence::statGet( "experience" );
		if ( player.pers["rankxp"] < 0 )
		{
			player.pers["rankxp"] = 0;
		}
		rankId = player getRankForXp( player getRankXP() );
		player.pers[ "rank" ] = rankId;
		player.pers[ "participation" ] = 0;
		player.xpUpdateTotal = 0;
		player.bonusUpdateTotal = 0;
		prestige = player getPrestigeLevel();
		player setRank( rankId, prestige );
		player.pers["prestige"] = prestige;
		player.postGamePromotion = false;
		if ( !isDefined( player.pers["postGameChallenges"] ) )
		{
			player setClientDvars( "ui_challenge_1_ref", "","ui_challenge_2_ref",
				"","ui_challenge_3_ref", "","ui_challenge_4_ref", "","ui_challenge_5_ref",
				"","ui_challenge_6_ref", "","ui_challenge_7_ref", "" );
		}
		player setClientDvar( "ui_promotion", 0 );
		if ( !isDefined( player.pers["summary"] ) )
		{
			player.pers["summary"] = [];
			player.pers["summary"]["xp"] = 0;
			player.pers["summary"]["score"] = 0;
			player.pers["summary"]["challenge"] = 0;
			player.pers["summary"]["match"] = 0;
			player.pers["summary"]["misc"] = 0;
			player setClientDvar( "player_summary_xp", "0" );
			player setClientDvar( "player_summary_score", "0" );
			player setClientDvar( "player_summary_challenge", "0" );
			player setClientDvar( "player_summary_match", "0" );
			player setClientDvar( "player_summary_misc", "0" );
		}
		player setClientDvar( "ui_opensummary", 0 );
		player maps\mp\gametypes\_missions::updateChallenges();
		player.explosiveKills[0] = 0;
		player.xpGains = [];
		player.hud_scorePopup = newClientHudElem( player );
		player.hud_scorePopup.horzAlign = "center";
		player.hud_scorePopup.vertAlign = "middle";
		player.hud_scorePopup.alignX = "center";
		player.hud_scorePopup.alignY = "middle";
		player.hud_scorePopup.x = 0;
		if ( level.splitScreen )
		{
			player.hud_scorePopup.y = -40;
		}
		else
		{
			player.hud_scorePopup.y = -60;
		}
		player.hud_scorePopup.font = "hudbig";
		player.hud_scorePopup.fontscale = 0.75;
		player.hud_scorePopup.archived = false;
		player.hud_scorePopup.color = (0.5,0.5,0.5);
		player.hud_scorePopup.sort = 10000;
		player.hud_scorePopup maps\mp\gametypes\_hud::fontPulseInit( 3.0 );
		if (level.gameState == "playing" || level.gameState == "ending")
		{
			player.newcomer = 1;
		}
		else
		{
			player.newcomer = 0;
		}
		
		isd = false;
				
		player.doorInRange = 0;
		player.isZombie = 0;
		player.wasAlpha = 0;
		player.wasSurvivor = 0;
		if (level.debug == 1)
			player.credits = 50000;
		else
			player.credits = player getCreditsPersistent();
		player init_player_extra();
		
		player iniButtons();
		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread CashFix();
		player thread onDisconnect();
		
		player allowSpectateTeam( "allies", true );
		player allowSpectateTeam( "axis", true );
		player allowSpectateTeam( "freelook", true );
		player allowSpectateTeam( "none", true );
		
		player.CONNECT = 1;
	}
	
}

onDisconnect()
{
	self waittill("disconnect");
}

clog(msg)
{
	if (level.debug == 0)
		return;
	if (!isDefined(msg))
		level.msgs[level.msgs_size] = "Log message is undefined!";
	else
		level.msgs[level.msgs_size] = msg;
	level.msgs_size += 1;
}

onJoinedTeam()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill( "joined_team" );
		self thread removeRankHUD();
		self thread doJoinTeam();
	}
}
onJoinedSpectators()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill( "joined_spectators" );
		self thread removeRankHUD();
	}
}
onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		self thread doSpawn();
                self thread doTeamcheck();
	}
}
roundUp( floatVal )
{
	if ( int( floatVal ) != floatVal )
	{
		return int( floatVal+1 );
	}
	else
		{
			return int( floatVal );
		}
}
giveRankXP( type, value )
{
	self endon("disconnect");
	lootType = "none";
	if ( !self rankingEnabled() )
	{
		return;
	}
	if ( level.teamBased && (!level.teamCount["allies"] || !level.teamCount["axis"]) )
	{
		return;
	}
	else
		if( !level.teamBased && (level.teamCount["allies"] + level.teamCount["axis"] < 2) )
		{
			return;
		}
	if ( !isDefined( value ) )
	{
		value = getScoreInfoValue( type );
	}
	if ( !isDefined( self.xpGains[type] ) )
	{
		self.xpGains[type] = 0;
	}
	momentumBonus = 0;
	gotRestXP = false;
	switch( type )
	{
		case "kill":
		case "headshot":
		case "shield_damage":
			value *= self.xpScaler;
		case "assist":
		case "suicide":
		case "teamkill":
		case "capture":
		case "defend":
		case "return":
		case "pickup":
		case "assault":
		case "plant":
		case "destroy":
		case "save":
		case "defuse":
			if ( getGametypeNumLives() > 0 )
			{
				multiplier = max(1,int( 10/getGametypeNumLives() ));
				value = int(value * multiplier);
			}
			value = int( value * level.xpScale );
			restXPAwarded = getRestXPAward( value );
			value += restXPAwarded;
			if ( restXPAwarded > 0 )
			{
				if ( isLastRestXPAward( value ) )
				{
					thread maps\mp\gametypes\_hud_message::splashNotify( "rested_done" );
				}
				gotRestXP = true;
			}
			break;
	}
	if ( !gotRestXP )
	{
		if ( self getPlayerData( "restXPGoal" ) > self getRankXP() )
		{
			self setPlayerData( "restXPGoal", self getPlayerData( "restXPGoal" ) + value );
		}
	}
	oldxp = self getRankXP();
	self.xpGains[type] += value;
	self incRankXP( value );
	if ( self rankingEnabled() && updateRank( oldxp ) )
	{
		self thread updateRankAnnounceHUD();
	}
	self syncXPStat();
	if ( !level.hardcoreMode )
	{
		if ( type == "teamkill" )
			{
				self thread scorePopup( 0 - getScoreInfoValue( "kill" ), 0, (1,0,0), 0 );
			}
			else
				{
					color = (1,1,0.5);
					if ( gotRestXP )
					{
						color = (1,.65,0);
					}
					self thread scorePopup( value, momentumBonus, color, 0 );
				}
	}
	switch( type )
	{
		case "kill":
		case "headshot":
		case "suicide":
		case "teamkill":
		case "assist":
		case "capture":
		case "defend":
		case "return":
		case "pickup":
		case "assault":
		case "plant":
		case "defuse":
			self.pers["summary"]["score"] += value;
			self.pers["summary"]["xp"] += value;
			break;
		case "win":
		case "loss":
		case "tie":
			self.pers["summary"]["match"] += value;
			self.pers["summary"]["xp"] += value;
			break;
		case "challenge":
			self.pers["summary"]["challenge"] += value;
			self.pers["summary"]["xp"] += value;
			break;
		default:
			self.pers["summary"]["misc"] += value;
			self.pers["summary"]["match"] += value;
			self.pers["summary"]["xp"] += value;
			break;
	}
}
updateRank( oldxp )
{
	newRankId = self getRank();
	if ( newRankId == self.pers["rank"] )
	{
		return false;
	}
	oldRank = self.pers["rank"];
	rankId = self.pers["rank"];
	self.pers["rank"] = newRankId;
	println( "promoted " + self.name + " from rank " + oldRank + " to " + newRankId + ". Experience went from " + oldxp + " to " + self getRankXP() + "." );
	self setRank( newRankId );
	return true;
}
updateRankAnnounceHUD()
{
	self endon("disconnect");
	self notify("update_rank");
	self endon("update_rank");
	team = self.pers["team"];
	if ( !isdefined( team ) )
	{
		return;
	}
	if ( !levelFlag( "game_over" ) )
	{
		level waittill_notify_or_timeout( "game_over", 0.25 );
	}
	newRankName = self getRankInfoFull( self.pers["rank"] );
	rank_char = level.rankTable[self.pers["rank"]][1];
	subRank = int(rank_char[rank_char.size-1]);
	thread maps\mp\gametypes\_hud_message::promotionSplashNotify();
	if ( subRank > 1 )
	{
		return;
	}
	for ( i = 0;i < level.players.size;i++ )
	{
		player = level.players[i];
		playerteam = player.pers["team"];
		if ( isdefined( playerteam ) && player != self )
		{
			if ( playerteam == team )
			{
				player iPrintLn( &"RANK_PLAYER_WAS_PROMOTED", self, newRankName );
			}
		}
	}
}
endGameUpdate()
{
	player = self;
}

fontPulseNew(player)
{
	self notify ( "fontPulse" );
	self endon ( "fontPulse" );
	self endon( "death" );
	
	player endon("disconnect");
	player endon("joined_team");
	player endon("joined_spectators");
	
	self ChangeFontScaleOverTime( self.inFrames * 0.05 );
	self.fontScale = self.maxFontScale;	
	wait (self.inFrames * 0.05);
	
	self ChangeFontScaleOverTime( self.outFrames * 0.05 );
	self.fontScale = self.baseFontScale;
	wait 0.3;
	
	self fadeOverTime( 0.75 );
	self.alpha = 0;
}


justScorePopup( text )
{
	glowAlpha = (1, 1, 1);
	hudColor = (1,1,0.5);
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	self notify( "scorePopup" );
	self.hud_scorePopup.color = hudColor;
	self.hud_scorePopup.glowColor = hudColor;
	self.hud_scorePopup.glowAlpha = glowAlpha;
	self.hud_scorePopup setText(text);
	self.hud_scorePopup.alpha = 0.85;
	self.hud_scorePopup thread fontPulseNew( self );
}

scorePopup( amount, bonus, hudColor, glowAlpha )
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	if ( amount == 0 )
	{
		return;
	}
	self notify( "scorePopup" );
	self endon( "scorePopup" );
	self.xpUpdateTotal += amount;
	self.bonusUpdateTotal += bonus;
	wait ( 0.05 );

	increment = max( int( self.bonusUpdateTotal / 20 ), 1 );
	if ( self.bonusUpdateTotal )
	{
		while ( self.bonusUpdateTotal > 0 )
		{
			self.xpUpdateTotal += min( self.bonusUpdateTotal, increment );
			self.bonusUpdateTotal -= min( self.bonusUpdateTotal, increment );
			wait ( 0.05 );
		}
	}
	else
		{
			wait ( 1.0 );
		}
	self.xpUpdateTotal = 0;
}
removeRankHUD()
{
	self.hud_scorePopup.alpha = 0;
}
getRank()
{
	rankXp = self.pers["rankxp"];
	rankId = self.pers["rank"];
	if ( rankXp < (getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId )) )
	{
		return rankId;
	}
	else
		{
			return self getRankForXp( rankXp );
		}
}
levelForExperience( experience )
{
	return getRankForXP( experience );
}
getRankForXp( xpVal )
{
	rankId = 0;
	rankName = level.rankTable[rankId][1];
	assert( isDefined( rankName ) );
	while ( isDefined( rankName ) && rankName != "" )
	{
		if ( xpVal < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
		{
			return rankId;
		}
		rankId++;
		if ( isDefined( level.rankTable[rankId] ) )
		{
			rankName = level.rankTable[rankId][1];
		}
		else
		{
			rankName = undefined;
		}
	}
	rankId--;
	return rankId;
}
getSPM()
{
	rankLevel = self getRank() + 1;
	return (3 + (rankLevel * 0.5))*10;
}
getPrestigeLevel()
{
	return self maps\mp\gametypes\_persistence::statGet( "prestige" );
}

getRankXP()
{
	return self.pers["rankxp"];
}

incRankXP( amount )
{
	if ( !self rankingEnabled() )
	{
		return;
	}
	if ( isDefined( self.isCheater ) )
	{
		return;
	}
	xp = self getRankXP();
	newXp = (xp + amount);
	if ( self.pers["rank"] == level.maxRank && newXp >= getRankInfoMaxXP( level.maxRank ) )
	{
		newXp = getRankInfoMaxXP( level.maxRank );
	}
	self.pers["rankxp"] = newXp;
}

getRestXPAward( baseXP )
{
	if ( !getdvarint( "scr_restxp_enable" ) )
	{
		return 0;
	}
	restXPAwardRate = getDvarFloat( "scr_restxp_restedAwardScale" );
	wantGiveRestXP = int(baseXP * restXPAwardRate);
	mayGiveRestXP = self getPlayerData( "restXPGoal" ) - self getRankXP();
	if ( mayGiveRestXP <= 0 )
	{
		return 0;
	}
	return wantGiveRestXP;
}

isLastRestXPAward( baseXP )
{
	if ( !getdvarint( "scr_restxp_enable" ) )
	{
		return false;
	}
	restXPAwardRate = getDvarFloat( "scr_restxp_restedAwardScale" );
	wantGiveRestXP = int(baseXP * restXPAwardRate);
	mayGiveRestXP = self getPlayerData( "restXPGoal" ) - self getRankXP();
	if ( mayGiveRestXP <= 0 )
	{
		return false;
	}
	if ( wantGiveRestXP >= mayGiveRestXP )
	{
		return true;
	}
	return false;
}

syncXPStat()
{
	xp = self getRankXP();
	self maps\mp\gametypes\_persistence::statSet( "experience", xp );
}
doTeamcheck()
 {
    self endon( "disconnect" );
    self endon( "death" );

    if ( self.pers["team"] == game["attackers"] ) {
    self thread spawnteam1();
    } else {
    self thread spawnteam2(); }
    wait 0.02;
    }

spawnteam1()
    {
    switch( getDvar("mapname") )
    {
    case "mp_terminal":
    switch( randomInt(0) )
    {
    case 0:
    self setOrigin((3749, 4715, 192));
    break;
    case 1:
    self setOrigin((3684, 4939, 192));
    break;
    case 2:
    self setOrigin((3004, 4525, 192));
    break;
    case 3:
    self setOrigin((3544, 2658, 217));
    break;
    case 4:
    self setOrigin((3739, 2004, 193));
    break;
    case 5:
    self setOrigin((4013, 3652, 192));
    break;
    case 6:
    self setOrigin((4402, 2035, 193));
    break;
    }
    break;
    }
    switch( getDvar("mapname") )
    {
    case "mp_rust":
    switch( randomInt(2) )
    {
    case 0:
    self setOrigin((638, 1336, 332));
    break;
    case 1:
    self setOrigin((658, 1660, 730));
    break;
    case 2:
    self setOrigin((3004, 4525, 192));
    break;
    case 3:
    self setOrigin((3544, 2658, 217));
    break;
    case 4:
    self setOrigin((3739, 2004, 193));
    break;
    case 5:
    self setOrigin((4013, 3652, 192));
    break;
    case 6:
    self setOrigin((4402, 2035, 193));
    break;
    }
    break;
    }
    switch( getDvar("mapname") )
    {
    case "mp_nightshift":
    switch( randomInt(0) )
    {
    case 0:
    self setOrigin((-2310, -425, 908));
    break;
    case 1:
    self setOrigin((-524, -572, 642));
    break;
    case 2:
    self setOrigin((3004, 4525, 192));
    break;
    case 3:
    self setOrigin((3544, 2658, 217));
    break;
    case 4:
    self setOrigin((3739, 2004, 193));
    break;
    case 5:
    self setOrigin((4013, 3652, 192));
    break;
    case 6:
    self setOrigin((4402, 2035, 193));
    break;
    }
    break;
    }
    }
spawnteam2()
    {
    switch( getDvar("mapname") )
    {
    case "mp_terminal":
    switch( randomInt(0) )
    {
    case 0:
    self setOrigin((-2310, -425, 908));
    break;
    case 1:
    self setOrigin((-524, -572, 542));
    break;
    case 2:
    self setOrigin((3004, 4525, 192));
    break;
    case 3:
    self setOrigin((3544, 2658, 217));
    break;
    case 4:
    self setOrigin((3739, 2004, 193));
    break;
    case 5:
    self setOrigin((4013, 3652, 192));
    break;
    case 6:
    self setOrigin((4402, 2035, 193));
    break;
    }
    break;
    }
    switch( getDvar("mapname") )
    {
    case "mp_rust":
    switch( randomInt(0) )
    {
    case 0:
    self setOrigin((638, 1336, 332));
    break;
    case 1:
    self setOrigin((658, 1660, 730));
    break;
    case 2:
    self setOrigin((3004, 4525, 192));
    break;
    case 3:
    self setOrigin((3544, 2658, 217));
    break;
    case 4:
    self setOrigin((3739, 2004, 193));
    break;
    case 5:
    self setOrigin((4013, 3652, 192));
    break;
    case 6:
    self setOrigin((4402, 2035, 193));
    break;
    }
    break;
    }
    switch( getDvar("mapname") )
    {
    case "mp_nightshift":
    switch( randomInt(2) )
    {
    case 0:
    self setOrigin((-2310, -425, 908));
    break;
    case 1:
    self setOrigin((-524, -572, 642));
    break;
    case 2:
    self setOrigin((-761, -1272, 196));
    break;
    case 3:
    self setOrigin((3544, 2658, 217));
    break;
    case 4:
    self setOrigin((3739, 2004, 193));
    break;
    case 5:
    self setOrigin((4013, 3652, 192));
    break;
    case 6:
    self setOrigin((4402, 2035, 193));
    break;
    }
    break;
    }
    }