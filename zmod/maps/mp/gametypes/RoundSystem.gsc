#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

doGameStarter()
{
	level.gameState = "starting";
	self.xxx2 = 0;
	level.lastAlive = 0;
	level.lastplayer = undefined;
	level waittill("CREATED");
	level thread doStartTimer();
	foreach(player in level.players)
		{
			if(player.xxx2 == 0)
			{
				player thread maps\mp\gametypes\HumanZombie::doSetup();
				player.xxx2 = 1;
		}
	}
	wait 50;
	level thread doZombieTimer();
	VisionSetNaked("icbm", 5);
}

doStartTimer()
{
	self.xxx2 = 0;
	level.counter = 50;
	level.TimerText destroy();
	level.Timer destroy();
	level.TimerText = level createServerFontString( "objective", 1.5 );
	level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
	level.TimerText setText("^2Game Starting in:");
	level.Timer = level createServerFontString( "objective", 2 );
	level.Timer setPoint( "CENTER", "CENTER", 0, -75 );
	level.Timer.color = (0,1,0);
	while(level.counter > 0)
	{
		level.Timer setValue(level.counter);
		setDvar("fx_draw", 1);
		foreach(player in level.players)
		{
			if(player.xxx2 == 0)
			{
				player thread maps\mp\gametypes\HumanZombie::doSetup();
				player.xxx2 = 1;
			}
		}
		wait 1;
		level.counter--;
	}
}

doMapVote()
{
	level.gamestate = "voting";
	notifyVoting = spawnstruct();
	notifyVoting.notifyText = "Vote for what the next map should be";
	notifyVoting.notifyText2 = "Not Voting counts as same map";
	current = getDvar("mapname");
	level.mapnumber1 = randomInt(level.mapvote.size);
	level.mapnumber2 = randomInt(level.mapvote.size);
	level.mapnumber3 = randomInt(level.mapvote.size);
	mapchoice1 = level.mapvote[level.mapnumber1];
	mapchoice2 = level.mapvote[level.mapnumber2];
	mapchoice3 = level.mapvote[level.mapnumber3];
	level.choice1votes = 0;
	level.choice2votes = 0;
	level.choice3votes = 0;
	level.keepmapvotes = 0;
	while(mapchoice1 == mapchoice2 || mapchoice2 == mapchoice3 || mapchoice3 == mapchoice1 || mapchoice1 == current || mapchoice2 == current || mapchoice3 == current)
	{
		if(mapchoice1 == mapchoice2){
			level.mapnumber1 = randomInt(level.mapvote.size);
			level.mapnumber2 = randomInt(level.mapvote.size);
			mapchoice1 = level.mapvote[level.mapnumber1];
			mapchoice2 = level.mapvote[level.mapnumber2];
		}
		if(mapchoice2 == mapchoice3){
			level.mapnumber2 = randomInt(level.mapvote.size);
			level.mapnumber3 = randomInt(level.mapvote.size);
			mapchoice2 = level.mapvote[level.mapnumber2];
			mapchoice3 = level.mapvote[level.mapnumber3];
		}
		if(mapchoice3 == mapchoice1){
			level.mapnumber1 = randomInt(level.mapvote.size);
			level.mapnumber3 = randomInt(level.mapvote.size);
			mapchoice1 = level.mapvote[level.mapnumber1];
			mapchoice3 = level.mapvote[level.mapnumber3];
		}
		if(mapchoice1 == current){
			level.mapnumber1 = randomInt(level.mapvote.size);
			mapchoice1 = level.mapvote[level.mapnumber1];
		}
		if(mapchoice2 == current){
			level.mapnumber2 = randomInt(level.mapvote.size);
			mapchoice2 = level.mapvote[level.mapnumber2];
		}
		if(mapchoice3 == current){
			level.mapnumber3 = randomInt(level.mapvote.size);
			mapchoice3 = level.mapvote[level.mapnumber3];
		}
	}
	wait 1;
	foreach(player in level.players)
	{
		player thread maps\mp\gametypes\_hud_message::resetNotify();
		player thread maps\mp\gametypes\HumanZombie::doSetup();
	}
	wait 4;
	VisionSetNaked("blacktest", 2);
	foreach(player in level.players)
	{
		player.menu = -1;
		player.mapvoted = 0;
		player.maxhealth = 99999;
		player.health = player.maxhealth;
		player.option1 setText("Press [{+smoke}] to vote for - " + level.mapname[level.mapnumber1]);
		player.option2 setText("Press [{+melee}] to vote for - " + level.mapname[level.mapnumber2]);
		player.option3 setText("Press [{+frag}] to vote for - " + level.mapname[level.mapnumber3]);
		player freezeControls(true);
		player thread maps\mp\gametypes\_hud_message::notifyMessage(notifyVoting);
	}
	level thread CountVotes();
	level thread MapVoteTimer();
	wait 20;
	level notify("EndMapVote");
	VisionSetNaked(getDvar("mapname"), 2);
	foreach(player in level.players)
	{
		if(player.mapvoted == 0){
			level.keepmapvotes++;
		}
	}
	foreach(player in level.players)
	{
		player.option1 setText(level.mapname[level.mapnumber1] + " - " + level.choice1votes);
		player.option2 setText(level.mapname[level.mapnumber2] + " - " + level.choice2votes);
		player.option3 setText(level.mapname[level.mapnumber3] + " - " + level.choice3votes);
	}
	level.TimerText setText("Keep the same map - " + level.keepmapvotes);
	wait 5;
	level notify("MapVotingOver");
	if(level.choice1votes > level.choice2votes && level.choice1votes > level.choice3votes && level.choice1votes > level.keepmapvotes){
		level thread ChangeMapTimer(level.mapname[level.mapnumber1]);
		wait 5;
		Map(level.mapvote[level.mapnumber1], false);
	} else if(level.choice2votes > level.choice1votes && level.choice2votes > level.choice3votes && level.choice2votes > level.keepmapvotes){
		level thread ChangeMapTimer(level.mapname[level.mapnumber2]);
		wait 5;
		Map(level.mapvote[level.mapnumber2], false);
	} else if(level.choice3votes > level.choice2votes && level.choice3votes > level.choice1votes && level.choice3votes > level.keepmapvotes){
		level thread ChangeMapTimer(level.mapname[level.mapnumber3]);
		wait 5;
		Map(level.mapvote[level.mapnumber3], false);
	} else if(level.keepmapvotes > level.choice1votes && level.keepmapvotes > level.choice2votes && level.keepmapvotes > level.choice3votes){
		wait 5;
		level thread doIntermission();
		foreach(player in level.players)
		{
			player.menu = 0;
			player freezeControls(false);
			player.maxhealth = 100;
			player.health = player.maxhealth;
		}
	} else if(level.choice1votes == level.choice2votes){
		if(cointoss()){
			level thread ChangeMapTimer(level.mapname[level.mapnumber1]);
			wait 5;
			Map(level.mapvote[level.mapnumber1], false);
		} else {
			level thread ChangeMapTimer(level.mapname[level.mapnumber2]);
			wait 5;
			Map(level.mapvote[level.mapnumber2], false);
		}
	} else if(level.choice2votes == level.choice3votes){
		if(cointoss()){
			level thread ChangeMapTimer(level.mapname[level.mapnumber2]);
			wait 5;
			Map(level.mapvote[level.mapnumber2], false);
		} else {
			level thread ChangeMapTimer(level.mapname[level.mapnumber3]);
			wait 5;
			Map(level.mapvote[level.mapnumber3], false);
		}
	} else if(level.choice3votes == level.choice1votes){
		if(cointoss()){
			level thread ChangeMapTimer(level.mapname[level.mapnumber1]);
			wait 5;
			Map(level.mapvote[level.mapnumber1], false);
		} else {
			level thread ChangeMapTimer(level.mapname[level.mapnumber3]);
			wait 5;
			Map(level.mapvote[level.mapnumber3], false);
		}
	} else if(level.choice1votes == level.keepmapvotes){
		if(cointoss()){
			level thread ChangeMapTimer(level.mapname[level.mapnumber1]);
			wait 5;
			Map(level.mapvote[level.mapnumber1], false);
		} else {
			wait 5;
			level thread doIntermission();
			foreach(player in level.players)
			{
				player.menu = 0;
				player freezeControls(false);
				player.maxhealth = 100;
				player.health = player.maxhealth;
			}
		}
	} else if(level.choice2votes == level.keepmapvotes){
		if(cointoss()){
			level thread ChangeMapTimer(level.mapname[level.mapnumber2]);
			wait 5;
			Map(level.mapvote[level.mapnumber2], false);
		} else {
			wait 5;
			level thread doIntermission();
			foreach(player in level.players)
			{
				player.menu = 0;
				player freezeControls(false);
				player.maxhealth = 100;
				player.health = player.maxhealth;
			}
		}
	} else if(level.choice3votes == level.keepmapvotes){
		if(cointoss()){
			level thread ChangeMapTimer(level.mapname[level.mapnumber3]);
			wait 5;
			Map(level.mapvote[level.mapnumber3], false);
		} else {
			wait 5;
			level thread doIntermission();
			foreach(player in level.players)
			{
				player.menu = 0;
				player freezeControls(false);
				player.maxhealth = 100;
				player.health = player.maxhealth;
			}
		}
	}
}

CountVotes()
{
	level endon("EndMapVote");
	for(;;)
	{
		foreach(player in level.players)
		{
			player.menu = -1;
			player.option1 setText("Press [{+smoke}] to vote for - " + level.mapname[level.mapnumber1]);
			player.option2 setText("Press [{+melee}] to vote for - " + level.mapname[level.mapnumber2]);
			player.option3 setText("Press [{+frag}] to vote for - " + level.mapname[level.mapnumber3]);
			if(player.mapvoted == 0){
				if(player SecondaryOffhandButtonPressed()){
					player.mapvoted = 1;
					level.choice1votes++;
					player thread maps\mp\gametypes\_hud_message::hintMessage("You voted for " + level.mapname[level.mapnumber1]);
				}
				if(player MeleeButtonPressed()){
					player.mapvoted = 1;
					level.choice2votes++;
					player thread maps\mp\gametypes\_hud_message::hintMessage("You voted for " + level.mapname[level.mapnumber2]);
				}
				if(player FragButtonPressed()){
					player.mapvoted = 1;
					level.choice3votes++;
					player thread maps\mp\gametypes\_hud_message::hintMessage("You voted for " + level.mapname[level.mapnumber3]);
				}
				player.hint = "You haven't voted yet!";
			} else {
				player.hint = "You have already voted!";
			}
		}
		wait .0001;
	}
}

MapVoteTimer()
{
	level endon("MapVotingOver");
	level.counter = 20;
	level.TimerText destroy();
	level.Timer destroy();
	level.TimerText = level createServerFontString( "objective", 1.5 );
	level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
	level.TimerText setText("^2Map Vote Ending in:");
	level.Timer = level createServerFontString( "objective", 2 );
	level.Timer setPoint( "CENTER", "CENTER", 0, -75 );
	level.Timer.color = (0,1,0);
	while(level.counter > 0)
	{
		level.Timer setValue(level.counter);
		VisionSetNaked("blacktest", 0);
		wait 1;
		level.counter--;
	}
	level.Timer destroy();
	while(1)
	{
		foreach(player in level.players)
		{
			player.menu = -1;
			player.option1 setText(level.mapname[level.mapnumber1] + " - " + level.choice1votes);
			player.option2 setText(level.mapname[level.mapnumber2] + " - " + level.choice2votes);
			player.option3 setText(level.mapname[level.mapnumber3] + " - " + level.choice3votes);
		}
		level.TimerText setText("Keep the same map - " + level.keepmapvotes);
		wait .25;
	}
}

ChangeMapTimer(nextmap)
{
	level.counter = 5;
	level.TimerText destroy();
	level.Timer destroy();
	level.TimerText = level createServerFontString( "objective", 1.5 );
	level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
	level.TimerText setText("^2Changing to " + nextmap + " in:");
	level.Timer = level createServerFontString( "objective", 2 );
	level.Timer setPoint( "CENTER", "CENTER", 0, -75 );
	level.Timer.color = (0,1,0);
	while(level.counter > 0)
	{
		level.Timer setValue(level.counter);
		VisionSetNaked("blacktest", 0);
		wait 1;
		level.counter--;
	}
}

doIntermission()
{
	level.gameState = "intermission";
	level.lastAlive = 0;
	level.lastplayer = undefined;
	level thread doIntermissionTimer();
	level notify("RESETDOORS");
	level notify("RESETCLUSTER");
	foreach(player in level.players)
	{
		foreach(sentry in player.Sentries)
		{
			sentry.SentryDamage notify("damage", 99999);
			sentry.SentryDamage delete();
			sentry notify("death");
			sentry delete();
		}
		player.Sentries = [];
		foreach(mine in player.Mines)
		{
			mine.Trigger delete();
			mine notify("detonateD");
			mine notify("detonateT");
			mine delete();
		}
		player.Mines = [];
	}
	setDvar("cg_drawCrosshair", 1);
	setDvar("cg_drawCrosshairNames", 1);
	setDvar("cg_drawFriendlyNames", 1);
	foreach(player in level.players)
	{
		player thread maps\mp\gametypes\HumanZombie::doSetup();
	}
	wait 50;
	level thread doZombieTimer();
	VisionSetNaked("icbm", 5);
}

doIntermissionTimer()
{
	self.xxx2 = 0;
	level.counter = 50;
	level.TimerText destroy();
	level.Timer destroy();
	level.TimerText = level createServerFontString( "objective", 1.5 );
	level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
	level.TimerText setText("^2Intermission:");
	level.Timer = level createServerFontString( "objective", 2 );
	level.Timer setPoint( "CENTER", "CENTER", 0, -75 );
	level.Timer.color = (0,1,0);
	while(level.counter > 0)
	{
		level.Timer setValue(level.counter);
		setDvar("fx_draw", 1);
		foreach(player in level.players)
		{
			if(player.xxx2 == 0)
			{
				player thread maps\mp\gametypes\HumanZombie::doSetup();
				player.xxx2 = 1;
			}
		}
		wait 1;
		level.counter--;
	}
}

doZombieTimer()
{
	setDvar("cg_drawCrosshair", 1);
	self.xxx2 = 0;
	level.counter = 20;
	while(level.counter > 0)
	{
		foreach(player in level.players)
		{
			if(player.xxx2 == 0)
			{
				player thread maps\mp\gametypes\HumanZombie::doSetup();
				player.xxx2 = 1;
			}
		}
		if(level.players.size > 1){
			level.TimerText destroy();
			level.Timer destroy();
			level.TimerText = level createServerFontString( "objective", 1.5 );
			level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
			level.TimerText setText("^1Zombies in:");
			level.Timer = level createServerFontString( "objective", 2 );
			level.Timer setPoint( "CENTER", "CENTER", 0, -75 );
			level.Timer setValue(level.counter);
			level.Timer.color = (1,0,0);
		} else {
			level.TimerText destroy();
			level.Timer destroy();
			level.TimerText = level createServerFontString( "objective", 1.5 );
			level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
			level.TimerText setText("^1Waiting for more Players");
			level.Timer = level createServerFontString( "objective", 2 );
			level.Timer setPoint( "CENTER", "CENTER", 0, -75 );
			level.Timer setValue("");
			level.Timer.color = (1,0,0);
			level.counter = 15;
		}
		wait 1;
		level.counter--;
	}
	level thread doPickZombie();
}

doPickZombie()
{
	level.Zombie1 = randomInt(level.players.size);
	level.Zombie2 = randomInt(level.players.size);
	level.Zombie3 = randomInt(level.players.size);
	level.Alpha = 2;
	if(level.players.size < 5){
		level.Alpha = 1;
	}
	if(level.players.size > 10){
		level.Alpha = 3;
	}
	if(level.Alpha == 1){
		level.players[level.Zombie1].isZombie = 2;
		level.players[level.Zombie1] thread maps\mp\gametypes\HumanZombie::doZombie();
	}
	if(level.Alpha == 2){
		while(level.Zombie1 == level.Zombie2){
			level.Zombie2 = randomInt(level.players.size);
		}
		level.players[level.Zombie1].isZombie = 2;
		level.players[level.Zombie1] thread maps\mp\gametypes\HumanZombie::doZombie();
		level.players[level.Zombie2].isZombie = 2;
		level.players[level.Zombie2] thread maps\mp\gametypes\HumanZombie::doZombie();
	}
	if(level.Alpha == 3){
		while(level.Zombie1 == level.Zombie2 || level.Zombie2 == level.Zombie3 || level.Zombie1 == level.Zombie3){
			level.Zombie2 = randomInt(level.players.size);
			level.Zombie3 = randomInt(level.players.size);
		}
		level.players[level.Zombie1].isZombie = 2;
		level.players[level.Zombie1] thread maps\mp\gametypes\HumanZombie::doZombie();
		level.players[level.Zombie2].isZombie = 2;
		level.players[level.Zombie2] thread maps\mp\gametypes\HumanZombie::doZombie();
		level.players[level.Zombie3].isZombie = 2;
		level.players[level.Zombie3] thread maps\mp\gametypes\HumanZombie::doZombie();
	}
	level playSoundOnPlayers("mp_defeat");
	level.timerText setText("^1Zombies RELEASED!");
	level.gameState = "playing";
	level thread doPlaying();
	level thread doPlayingTimer();
	level thread inGameConstants();
	level thread maps\mp\gametypes\HumanZombie::HumanSpeech();
}

doPlaying()
{
	level.Timer destroy();
	level.playersLeft = maps\mp\gametypes\_teams::CountPlayers();
	wait 5;
	level.TimerText destroy();
	while(1)
	{
		level.playersLeft = maps\mp\gametypes\_teams::CountPlayers();
		if(level.lastAlive == 0){
			if(level.playersLeft["allies"] == 1){
				level.lastAlive = 1;
				foreach(player in level.players){
					if(player.team == "allies"){
						level.lastplayer = player;
						player thread maps\mp\gametypes\HumanZombie::doLastAlive();
						level thread teamPlayerCardSplash( "callout_lastteammemberalive", player, "allies" );
						level thread teamPlayerCardSplash( "callout_lastenemyalive", player, "axis" );
					}
				}
			}
		}
		if(level.playersLeft["allies"] == 0 || level.playersLeft["axis"] == 0){
			level thread doEnding();
			return;
		}
		foreach(player in level.players)
		{
			if(player.xxx2 == 0)
			{
				player thread maps\mp\gametypes\HumanZombie::doZombie();
			}
		}
		wait .1;
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
		if(level.seconds == 60){
			level.minutes++;
			level.seconds = 0;
		}
		if(level.gameState == "ending"){
			return;
		}
	}
}

doEnding()
{
	level notify("EndSpeech");
	level.gameState = "ending";
	notifyEnding = spawnstruct();
	notifyEnding.titleText = "Round Over!";
	
	if(level.playersLeft["allies"] == 0){
		notifyEnding.notifyText = "Humans Survived: " + level.minutes + " minutes " + level.seconds + " seconds.";
	}
	if(level.playersLeft["axis"] == 0){
		notifyEnding.notifyText = "All the Zombies disappeared!";
	}
	wait 1;
	VisionSetNaked("blacktest", 2);
	foreach(player in level.players)
	{
		player thread maps\mp\gametypes\_hud_message::resetNotify();
		player _clearPerks();
		player freezeControls(true);
		player thread maps\mp\gametypes\_hud_message::notifyMessage( notifyEnding );
	}
	wait 3;
	VisionSetNaked(getDvar( "mapname" ), 2);
	foreach(player in level.players)
	{
		player freezeControls(false);
	}
	level thread doMapVote();
}

inGameConstants()
{
	while(1)
	{
		setDvar("cg_drawCrosshair", 1);
		setDvar("cg_drawCrosshairNames", 0);
		setDvar("cg_drawFriendlyNames", 0);
		foreach(player in level.players){
				player VisionSetNakedForPlayer("icbm", 0);
			player setClientDvar("lowAmmoWarningNoAmmoColor2", 0, 0, 0, 0);
			player setClientDvar("lowAmmoWarningNoAmmoColor1", 0, 0, 0, 0);
			player setClientDvar("cg_drawCrosshairNames", 0);
			player setClientDvar("cg_drawFriendlyNames", 0);
			player setClientDvar("fx_draw", 1);
			player setClientDvar("r_drawsun", 0);
			player setClientDvar("sm_sunenable", 0);
			if(player.isZombie == 0){
					player setClientDvar("r_brightness", -.1);
			} else {
				player setClientDvar("r_brightness", 0);
			}
		}
		wait 1;
		if(level.gameState == "ending"){
			return;
		}
	}
}
