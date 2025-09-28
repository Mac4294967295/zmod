#include maps\mp\gametypes\_rank;
#include maps\mp\_utility;
#include maps\mp\gametypes\_shop_menu;
#include common_scripts\utility;

doSpawn()
{
	//Exits
	self endon ( "game_ended" );

	if (self.spawning == 1)
		return;

	if ( level.gameState == "postgame" )
		return;

	//Spawn Player
	self.spawning = 1;

	if( level.gameState == "playing" )
	{
		if(self getCItemVal("life", "in_use") > 0 && self.isZombie == 0 && self.isAlpha == 0)
		{
			self.bonuscash = 1;
			self setCItemVal("life", "in_use", self getCItemVal("life", "in_use") - 1);
			self SpawnPlayer( "allies" );
		}
		else
		{
			if (!self.isZombie) {
				self.kills = 0;
				self.bounty = 0;
				self.credit_kills = self.kills;
			}
			self SpawnPlayer( "axis" );
		}
	}
	else
	{
		self.bounty = 0;
		self.bonuscash = 1;
		self.isAlpha = 0;
		self SpawnPlayer( "allies" );
	}

	self.spawning = 0;

	//Post Spawn Setups
	if(!self.isZombie)
	{
		self doHumanSetup();
		self maps\mp\gametypes\_credit_items::giveCreditUpgrades();
	}
	else
	{
		self doZombieSetup();
	}

	self.combo = 0;
	self.menu = 0;
	self.isRepairing = false;

	if( self getCItemVal("cash", "in_use") == 1 && self.bonuscash)
	{
		self.bounty = 200;
		self.bonuscash = 0;
	}

	//self statCashAdd(5000); // Starting cash for testing

	//self IPrintLnBold("do spawn");
	self notify( "zmod_shop_change" );
	self notify( "HEALTH" );
	self notify( "LIVES" );
	self notify( "CASH" );
}

SpawnPlayer( team )
{
	self thread SetPlayerTeam( team );
	self waittill_any( "spawned_player", "zmod_setplayerteam_none" );

	self maps\mp\gametypes\_SpawnPoints::SpawnPlayer();

	if( self.team == "axis" )
		self.isZombie = 1;

	if( self.team == "allies" )
		self.isZombie = 0;

	if( level.gameState == "pregame" )
	{
		self freezeControls(true);
		self VisionSetNakedForPlayer("mpIntro", 0);
	}
}

SetPlayerTeam( team )
{
	if( self.team != team )
	{
		//self iprintln( "SetPlayerTeam" );
		logprint( self.name + "SetPlayerTeam" + "\n" );

		if( team == "allies" )
		{
			//TODO: if removing this is problematic, put it in again and remove the self.team != team check at the top
			//self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self maps\mp\gametypes\_menus::addToTeam( "allies" );
		}
		else if ( team == "axis" )
		{
			//TODO: if removing this is problematic, put it in again and remove the self.team != team check at the top
			//self.switching_teams = true;
			self.joining_team = "axis";
			self.leaving_team = self.pers["team"];
			self maps\mp\gametypes\_menus::addToTeam( "axis" );
		}

		self SetPlayerClass();
		self suicide();
	}
	else
	{
		self waitframe();
		self notify( "zmod_setplayerteam_none" );
	}
}

/*
validClass( team )
{
	if( team == "allies" && self.class == "class0" )
		return 1;

	if( team == "axis" && self.class == "class3" )
		return 1;

	return 0;
}
*/

SetPlayerClass()
{
	//self iprintln( "SetPlayerClass" );
	logprint( self.name + "SetPlayerClass" + "\n" );

	if ( self.team == "axis")
	{
		class = "class3";
		self.pers["class"] = class;
		self.class = class;
	}
	else if ( self.team == "allies" )
	{
		class = "class0";
		self.pers["class"] = class;
		self.class = class;
	}
}

doHumanSetup()
{
	//iprintln( "Human Setup" );
	//logprint( self.name + "Human Setup" + "\n" );

	self thread maps\mp\gametypes\_zmod_hud::doLives();
	self _clearPerks();

	self.grenades = 3;

	self setHItemVal("weaponhandling", "text1", "Upgrade Weapon Handling (0/3) - ");

	self _unsetperk("specialty_bulletaccuracy");
	self SetClientDvar("perk_weapSpreadMultiplier", "1");
	self _unsetperk("specialty_holdbreath");
	self _unsetperk("specialty_fastreload");
	self _unsetperk("specialty_quickdraw");

	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_fastsprintrecovery");

	self.moveSpeedScaler = 1.07;
	self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
	self resetHMenu();
	self.maxhealth = 100;


	self thread setupWeapons();
}

doZombieSetup()
{
	//iprintln( "Zombie Setup" );
	//logprint( self.name + "Zombie Setup" + "\n" );

	self _clearPerks();

	self.grenades = 0;

	SetDvar("player_sprintUnlimited", 1);
	self maps\mp\perks\_perks::givePerk("specialty_fastsprintrecovery");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	self maps\mp\perks\_perks::givePerk("specialty_thermal");

	self.moveSpeedScaler = 1.07;
	self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );

	self SetOffhandPrimaryClass("");

	self setWeaponAmmoClip("frag_grenade_mp", 0);
	self setWeaponAmmoStock("frag_grenade_mp", 0);

	self takeAllWeapons();

	self giveWeapon("usp_tactical_mp", 0, false);
	self setWeaponAmmoClip("usp_tactical_mp", 0);
	self setWeaponAmmoStock("usp_tactical_mp", 0);

	wait .2;
	self switchToWeapon("usp_tactical_mp");
	self maps\mp\gametypes\_zombie_items::giveZUpgrades();
}

monitorPlayerWeapons()
{
	self endon( "disconnect" );

	while(1)
	{
		wait 0.5;
		/*Takes all weapons from zombie which Zombies cant have (i.e.: Picking up weapons from ground)*/
		if(
			self getCurrentWeapon() != "usp_tactical_mp" 
			&& self getCurrentWeapon() != "riotshield_mp"
			&& self.isZombie 
			&& isAlive( self ) 
			&& self getCurrentWeapon() != "stinger_mp" 
		) {
			self takeAllWeapons();
			self giveWeapon("usp_tactical_mp", 0, false);
			self setWeaponAmmoClip("usp_tactical_mp", 0);
			self setWeaponAmmoStock("usp_tactical_mp", 0);
			wait .4;
			self switchToWeapon("usp_tactical_mp");

			if(self getZItemVal("riotshield", "in_use")==1)
			{
				self giveWeapon("riotshield_mp", 0, false);
			}
		}
	}
}

pickZombie()
{
	self endon ( "game_ended" );

	if( level.players.size == 0)
	{
		level waittill( "connected", player );
		wait 10;
	}

	//iprintln( "pickZombie" );
	//logprint( self.name + "pickZombie" + "\n" );

	numberOfZombies=int(level.players.size / 6 + 1);
	zombiePicked = 0;

	for(i=0;i<numberOfZombies;i++)
	{
		while(1)
		{
			rnd = randomInt(level.players.size);

			if(!isDefined(level.players[rnd]))
				continue;

			randPlayer = level.players[rnd];

			if( randPlayer getCItemVal("antialpha", "in_use") == 0 )
			{
				break;
			}
			else
			{
				randPlayer iPrintlnBold("^2Anti-Alpha used!");
				randPlayer setCItemVal("antialpha", "in_use", 0);
				randPlayer thread maps\mp\gametypes\_shop_menu::monitorShop();
			}
		}
		if(!zombiePicked) {
			zombiePicked = 1;
			level.gameState = "playing";
			level notify("gamestatechange");
		}

		//iprintln( "picked Zombie: " + randplayer.name + "\n" );
		logprint( self.name + "picked Zombie: " + randPlayer.name );

		randPlayer.isAlpha = 1;
		randPlayer.bonuscash = 1;
		randPlayer doSpawn();
	}

	level thread maps\mp\gametypes\_zmod_gamelogic::doPlaying();
	level thread maps\mp\gametypes\_zmod_gamelogic::doPlayingTimer();
	level thread maps\mp\gametypes\_zmod_gamelogic::inGameConstants();
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "spawned_player" );
		//self iprintln( "spawned_player: " + self.spawning );
		//logprint( self.name + "spawned_player: " + self.spawning + "\n" );

		if( self.spawning == 0 )
			self thread doSpawn();
	}
}

setupWeapons() {
	self.randomlmg = randomInt(level.lmg.size);
	self.randomar = randomInt(level.assault.size);
	self.randommp = randomInt(level.machine.size);
	self.randomsmg = randomInt(level.smg.size);
	self.randomsr = randomInt(level.rifle.size);
	self.randomshot = randomInt(level.shot.size);
	self.randomhand = randomInt(level.hand.size);

	self takeAllWeapons();
	self giveWeapon(level.smg[self.randomsmg] + "_mp", 0, false);
	self GiveMaxAmmo(level.smg[self.randomsmg] + "_mp");
	wait .5;
	self switchToWeapon(level.smg[self.randomsmg] + "_mp");
	self thread monitorGrenades();
	wait .5;
	self maps\mp\gametypes\_shop_menu::monitorShop();
}

monitorGrenades()
{
	self endon("disconnect");
	self endon("death");
	while(level.gamestate!="playing") wait 1;
	if(!self hasWeapon("flare_mp")){
		self SetOffhandPrimaryClass( "frag" );
		self _giveWeapon("frag_grenade_mp", 1);
	}
	while(self.isZombie==0)
	{
		if(self.c4array.size==0)
		{
			if(self.grenades>0 )
			{
				if(self getWeaponAmmoStock(level.explosives[self  getHItemVal("grenade", "in_use")]+"_mp") == 0)
				{
					self.grenades--;
					self setWeaponAmmoStock(level.explosives[self  getHItemVal("grenade", "in_use")]+"_mp", 1);
				}
			}
			wait .2;
		}
		wait .2;
	}
}

monitorTI(){
	self endon("disconnect");
	self endon("death");
	wait .7;
	while(self hasWeapon("flare_mp")) wait .5;
	if(level.gamestate=="playing") {
		self SetOffhandPrimaryClass( "frag" );
		self _giveWeapon("frag_grenade_mp", 1);
	}
}
