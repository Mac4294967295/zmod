#include maps\mp\gametypes\_rank;
#include maps\mp\_utility;
#include maps\mp\gametypes\_shop_menu;

doSpawn()
{
	if( level.gameState != "postgame" )
	{	
		self.menu = 0;
		self.grenades = 3;
		self.isRepairing = false;

		if(level.gameState=="playing"/* || level.gameState=="ending"*/)
		{
			if(self getCItemVal("life", "in_use") > 0 && self.isZombie == 0 )
			{
				self setCItemVal("life", "in_use", self getCItemVal("life", "in_use") - 1);
				self doHumanSetup();
				self maps\mp\gametypes\_credit_items::giveCreditUpgrades();
			}
			else
			{
				if(self.team != "axis" )
				{				
					self SpawnPlayer( "axis" );
					self.bounty=0;
					return;
				}
				else
				{
					self.isZombie = 1;					
					self doZombieSetup();
				}			
			}
		}
		else
		{
			if(self.team == "axis" || self.team == "spectator")
			{
				self SpawnPlayer( "allies" );
				return;
			}
			
			self.isZombie = 0;
			self doHumanSetup();
			self maps\mp\gametypes\_credit_items::giveCreditUpgrades();
		}
		
		self thread maps\mp\gametypes\_shop_menu::CreatePlayerHUD();
		maps\mp\gametypes\_shop_menu::doShop();
		self thread maps\mp\gametypes\_shop_menu::monitorShop();
		self thread maps\mp\gametypes\_zmod_hud::doCash();
		self thread maps\mp\gametypes\_zmod_hud::doHealth();
		
		self.combo = 0;
		self statCashAdd(5000);
		
		if(level.gamestate == "starting")
		{
			self thread OMAExploitFix();
		}
	}	
}

SpawnPlayer( team )
{
	if(isDefined( team ))
	{
		self SetPlayerTeam( team );
	}
	else
	{
		self SetPlayerTeam();
	}
	
	self SetPlayerClass();	
}

SetPlayerTeam( team )
{
	self.switching_teams = true;
	
	if(!isDefined(team) && self.team == "axis" || isDefined(team) && team == "allies")
	{
		self.joining_team = "allies";
		self.leaving_team = self.pers["team"];
		self maps\mp\gametypes\_menus::addToTeam( "allies" );
	}
	else if ( !isDefined(team) && self.team == "allies" || isDefined(team) && team == "axis")
	{
		self.joining_team = "axis";
		self.leaving_team = self.pers["team"];
		self maps\mp\gametypes\_menus::addToTeam( "axis" );
	}
	
	self suicide();
}

SetPlayerClass()
{
	if ( self.team == "axis")
	{
		class = self maps\mp\gametypes\_class::getClassChoice( "class3" );
		primary = self maps\mp\gametypes\_class::getWeaponChoice( "class3" );
		self.pers["class"] = class;
		self.class = class;
		self.pers["primary"] = primary;	
	}
	else if ( self.team == "allies" )
	{
		class = self maps\mp\gametypes\_class::getClassChoice( "class0" );
		primary = self maps\mp\gametypes\_class::getWeaponChoice( "class0" );		
		self.pers["class"] = class;
		self.class = class;
		self.pers["primary"] = primary;	
	}
}

doHumanSetup(){
	self thread maps\mp\gametypes\_zmod_hud::doLives();
	self _clearPerks();
	
	self setHItemVal("recoilcontrol", "text1", "Upgrade Recoil Control (0/3) - ");
	
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
	self SetOffhandPrimaryClass( "frag" );
	self _giveWeapon("frag_grenade_mp", 1);
	self thread monitorGrenades();
	wait .5;
	self switchToWeapon(level.smg[self.randomsmg] + "_mp");
}

doZombieSetup(){
	self _clearPerks();
	
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

pickZombie()
{
	self endon ( "game_ended" );
	
	noPlayers=false;
	while(level.players.size==0)
	{
		wait 4;
		noPlayers=true;
	}
	if(noPlayers) wait 10;
	
	numberOfZombies=int(level.players.size/6)+1;
	
	for(i=0;i<numberOfZombies;i++)
	{
		while(1)
		{
			rnd = randomInt(level.players.size);
			
			if(!isDefined(level.players[rnd])) 
				return;
			
			randPlayer = level.players[rnd];
			
			if( randPlayer getCItemVal("antialpha", "in_use") == 0 )
			{
				break;
			}
			else
			{
				randPlayer setCItemVal("antialpha", "in_use", 0);
				randPlayer iPrintlnBold("^2Anti-Alpha used!");
			}
		}

		randPlayer SpawnPlayer( "axis" );

		randPlayer.isZombie=1;
		level.gameState = "playing";
		level notify("gamestatechange");
	}
	
	level.gameState = "playing";
	level notify("gamestatechange");
	level thread maps\mp\gametypes\_zmod_gamelogic::doPlaying();
	level thread maps\mp\gametypes\_zmod_gamelogic::doPlayingTimer();
	level thread maps\mp\gametypes\_zmod_gamelogic::inGameConstants();
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");

		if(!(self getCItemVal("life", "in_use") > 0 && self.isZombie == 0 )) //if is respawing due to lives dont respawn at default spawn but at random or tac insertion
			self maps\mp\gametypes\_SpawnPoints::SpawnPlayer();

		self thread doSpawn();

		if( level.gameState == "pregame" )
		{
			self freezeControls(true);
			self VisionSetNakedForPlayer("mpIntro", 0);
		}
	}
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

monitorGrenades()
{
	self endon("disconnect");
	self endon("death");

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