#include maps\mp\gametypes\_rank;
#include maps\mp\_utility;
#include maps\mp\gametypes\_shop_menu;

doSpawn(){
  //self iPrintLnBold(level.gamestate+" "+self getCItemVal("life", "in_use")+" "+self.isZombie);
  //wait 2;
  self.menu=0;
  if(level.gameState=="playing" || level.gameState=="ending"){
    if(self getCItemVal("life", "in_use")>0 && self.isZombie==0){
      self setCItemVal("life", "in_use", self getCItemVal("life", "in_use")-1);
      self doHumanSetup();
    }else{
      self doZombieSetup();
    }
  }else{
    self.isZombie=0;
    self doHumanSetup();
  }
  self maps\mp\gametypes\_credit_items::giveCreditUpgrades();
  self thread CreatePlayerHUD();
  self thread destroyOnDeath();
  self thread maps\mp\gametypes\_shop_menu::doShop();
  self thread maps\mp\gametypes\_shop_menu::monitorShop();
  self thread maps\mp\gametypes\_shop_menu::doMenuScroll();
  self.combo = 0;
  self statCashAdd(5000);
	if(level.gamestate == "starting")
	{
		self thread OMAExploitFix();
	}

}

doHumanSetup(){
  self thread maps\mp\gametypes\_rank::doLives();
  self thread maps\mp\gametypes\_rank::doCash();
  self _clearPerks();
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
	self maps\mp\perks\_perks::givePerk("specialty_quieter");
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
	self giveWeapon(level.shot[self.randomshot] + "_mp", 0, false);
	self giveWeapon(level.hand[self.randomhand] + "_mp", 0, false);
	self GiveMaxAmmo(level.smg[self.randomsmg] + "_mp");
	self GiveMaxAmmo(level.shot[self.randomshot] + "_mp");
	self GiveMaxAmmo(level.hand[self.randomhand] + "_mp");
  wait 0.2;
	self switchToWeapon(level.smg[self.randomsmg] + "_mp");
  //self thread doHW();

}

doZombieSetup(){
  self _clearPerks();
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	self maps\mp\perks\_perks::givePerk("specialty_thermal");
  self takeAllWeapons();
	self giveWeapon("usp_tactical_mp", 0, false);
  self setWeaponAmmoClip("usp_tactical_mp", 0);
  self setWeaponAmmoStock("usp_tactical_mp", 0);
  wait .2;
  self switchToWeapon("usp_tactical_mp");
	self maps\mp\gametypes\_zombie_items::giveZUpgrades();
}
