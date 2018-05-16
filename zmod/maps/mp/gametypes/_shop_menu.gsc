#include maps\mp\gametypes\_rank;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_zombie_items;
#include maps\mp\gametypes\_human_items;
#include maps\mp\gametypes\_credit_items;
/*
Initializes shop items:
name: reference to the item
every item has 7 variables: cost, page, pos, text1, text2, print_text, in_use
ZArray enables to find the name of a item directly by its page & pos in the shop; is used to print the menu
*/
initZShopItem(name, cost, page, pos, text1, text2){
	self.ZMenu[name]["cost"] = cost;
	self.ZMenu[name]["page"] = page;
	self.ZMenu[name]["pos"] = pos;
	self.ZMenu[name]["text1"] = text1 + cost;
	self.ZMenu[name]["text2"] = text2;
	self.ZMenu[name]["print_text"] = "text1";
	self.ZMenu[name]["in_use"] = 0;
	self.ZArray[page][pos] = name; //initializes ZArray
	//level.ZFuncArray[page][pos] = ::[[name]];
}

initHShopItem(name, cost, page, pos, text1, text2){
	self.HMenu[name]["cost"] = cost;
	self.HMenu[name]["page"] = page;
	self.HMenu[name]["pos"] = pos;
	self.HMenu[name]["text1"] = text1 + cost;
	self.HMenu[name]["text2"] = text2;
	self.HMenu[name]["print_text"] = "text1";
	self.HMenu[name]["in_use"] = 0;
	self.HArray[page][pos] = name; //initializes ZArray
	//level.ZFuncArray[page][pos] = ::name;
}

initCShopItem(name, cost, page, pos, text1, text2){
	self.CMenu[name]["cost"] = cost;
	self.CMenu[name]["page"] = page;
	self.CMenu[name]["pos"] = pos;
	self.CMenu[name]["text1"] = text1 + cost;
	self.CMenu[name]["text2"] = text2;
	self.CMenu[name]["print_text"] = "text1";
	self.CMenu[name]["in_use"] = 0;
	self.CArray[page][pos] = name; //initializes CArray
}
/*
(re)sets the items and its variables
*/
initializeItemFuncArray(){
	level.CFuncArray[10][3] = [];

	level.CFuncArray[0][0]=::life;
	level.CFuncArray[0][1]=::tacticalinsertion;
	level.CFuncArray[0][2]=::finalstand;

	level.CFuncArray[1][0]=::antialpha;
	level.CFuncArray[1][1]=::cash;


	level.ZFuncArray[10][3] = [];

	level.ZFuncArray[0][0]=::health;
	level.ZFuncArray[0][1]=::wallhack;
	level.ZFuncArray[0][2]=::throwingknife;

	level.ZFuncArray[1][0]=::coldblood;
	level.ZFuncArray[1][1]=::ninja;
	level.ZFuncArray[1][2]=::movespeed;

	level.ZFuncArray[2][0]= "";
	level.ZFuncArray[2][1]=::stinger;
	level.ZFuncArray[2][2]=::commando;

	level.ZFuncArray[3][0]=::blastshield;
	level.ZFuncArray[3][1]=::zriotshield;
	level.ZFuncArray[3][2]=::_suicide;



	level.HFuncArray[10][3] = [];

	level.HFuncArray[0][0]=::ammo;
	level.HFuncArray[0][1]=::extendedmags;
	level.HFuncArray[0][2]=::sight;

	level.HFuncArray[1][0]=::smg;
	level.HFuncArray[1][1]=::assault;
	level.HFuncArray[1][2]=::lmg;

	level.HFuncArray[2][0]=::pistol;
	level.HFuncArray[2][1]=::shotgun;
	level.HFuncArray[2][2]=::sniper;

	level.HFuncArray[3][0]=::hriotshield;
	level.HFuncArray[3][1]=::akimbo;
	level.HFuncArray[3][2]=::repair;

	level.HFuncArray[4][0]=::grenade;
	level.HFuncArray[4][1]=::weaponhandling;
	level.HFuncArray[4][2]=::rpg;

	level.HFuncArray[5][0]=::predator_missile;
	level.HFuncArray[5][1]=::harrier_airstrike;
	level.HFuncArray[5][2]=::helicopter_flares;

	level.HFuncArray[6][0]=::sentry;
	level.HFuncArray[6][1]=::helicopter_minigun;
	level.HFuncArray[6][2]=::ac130;

	level.HFuncArray[7][0]=::stealth_airstrike;
	level.HFuncArray[7][1]=::artillery;
	level.HFuncArray[7][2]=::nuke;

	level.HFuncArray[8][0]=::betterdevils;
	level.HFuncArray[8][1]=::grimreaper;

}
/*
resets all the "in_use" variables of the items
*/
resetZMenu(){
	for(i=0;i<self.ZArray.size;i++){
		for(j=0;j<3;j++){
			if(isDefined(self.ZArray[i][j])){
				self setZItemVal(self.ZArray[i][j], "in_use", 0);
				self setZItemVal(self.ZArray[i][j], "print_text", "text1");
			}
		}
	}
}
/*
resets all the "in_use" variables of the items
*/
resetHMenu(){
	for(i=0;i<self.HArray.size;i++){
		for(j=0;j<3;j++){
			if(isDefined(self.HArray[i][j])){
				self setHItemVal(self.HArray[i][j], "in_use", 0);
				self setHItemVal(self.HArray[i][j], "print_text", "text1");
			}
		}
	}
}

resetCMenu(){
	for(i=0;i<self.CArray.size;i++){
		for(j=0;j<3;j++){
			if(isDefined(self.CArray[i][j])){
				self setCItemVal(self.CArray[i][j], "in_use", 0);
				self setCItemVal(self.CArray[i][j], "print_text", "text1");
			}
		}
	}
}

initializeCMenu(){
	self.CMenu[100][7] = [];
	self.CArray[4][3] = []; //stores name of shop item in regard to position; is used for printing the menu
	initCShopItem("life", 300, 0, 0, "[Human] Buy Extra Life - ", "");
	initCShopItem("tacticalinsertion", 250, 0, 1, "[Human] Buy Tactical Insertion for extra lives - ", "^1Tactical Insertion equipped");
	initCShopItem("finalstand", 500, 0, 2, "[Human] Buy Finalstand - ", "^1Finalstand activated");
	initCShopItem("antialpha", 200, 1, 0, "Buy Anti-Alpha ", "^1Anti-Alpha activated");
	initCShopItem("cash", 200, 1, 1, "Buy 200 Starting Cash (Human & Alpha Zombie) ", "^1Starting Cash acquired");

}
/*
builds the array.
*/
initializeZMenu(){
	self.ZMenu[100][7] = [];
	self.ZArray[4][3] = []; //stores name of shop item in regard to position; is used for printing the menu
	initZShopItem("health", 50, 0, 0, "Buy Health - ", "^1Max Health achieved");
	initZShopItem("wallhack", 200, 0, 1, "Buy Wallhack - ", "^1Wallhack activated");
	initZShopItem("throwingknife", 300, 0, 2, "Buy a Throwing Knife - ", "^1Throwing Knife equipped");

	initZShopItem("coldblood", 150, 1, 0, "Buy Coldblood - ", "^1Coldblood activated ()");
	initZShopItem("ninja", 100, 1, 1, "Buy Ninja - ", "^1Ninja activated");
	initZShopItem("movespeed", 50, 1, 2, "Buy Movespeed - ", "^1Max Movespeed achieved");

	initZShopItem("placeholder", 100, 2, 0, "Buy PLACEHOLDER - ", "^1PLACEHOLDER activated");
	initZShopItem("stinger", 150, 2, 1, "Buy Stinger - ", "^1Stinger equipped");
	initZShopItem("commando", 200, 2, 2, "Buy Commando - ", "^1Commando activated");

	initZShopItem("blastshield", 300, 3, 0, "Buy Blastshield - ", "^1Equip/Unequip Blastshield");
	initZShopItem("riotshield", 150, 3, 1, "Buy Riotshield - ", "^1 Riotshield equipped");
	initZShopItem("suicide", "", 3, 2, "Suicide", "");
}
initializeHMenu(){
	self.HMenu[100][7] = [];
	self.HArray[9][3] = []; //stores name of shop item in regard to position; is used for printing the menu
	initHShopItem("ammo", 100, 0, 0, "Buy Ammo - ", "^1current weapon ammo full");
	initHShopItem("extendedmags", 150, 0, 1, "Buy Extended Mags - ", "^1Extended Mags equipped");
	initHShopItem("sight", 50, 0, 2, "Unlock Sights - ", "Swap Sight");

	initHShopItem("smg", 100, 1, 0, "Buy SMG - ", "Swap SMG");
	initHShopItem("assault", 150, 1, 1, "Buy AR - ", "Swap AR");
	initHShopItem("lmg", 200, 1, 2, "Buy LMG - ", "Swap LMG");

	initHShopItem("pistol", 100, 2, 0, "Buy Pistol - ", "Swap Pistol");
	initHShopItem("shotgun", 150, 2, 1, "Buy Shotgun - ", "Swap Shotgun");
	initHShopItem("sniper", 200, 2, 2, "Buy Sniper - ", "Swap Sniper");

	initHShopItem("riotshield", 200, 3, 0, "Buy Riotshield - ", "^1Riotshield already equipped");
	initHShopItem("akimbo", 50, 3, 1, "Buy Akimbo - ", "^1Akimbo unavailable");
	initHShopItem("repair", 250, 3, 2, "Buy Repair Tool  - ", "^1Unavailable");

	initHShopItem("grenade", 150, 4, 0, "Unlock Explosives - ", "Swap Explosive");
	initHShopItem("weaponhandling", 100, 4, 1, "Upgrade Weapon Handling (0/3) - ", "^1Weapon Handling (3/3)");
	initHShopItem("rpg", 150, 4, 2, "Buy RPG - ", "^1Unavailable");

	initHShopItem("predator_missile", 150, 5, 0, "Buy Predator - ", "");
	initHShopItem("harrier_airstrike", 450, 5, 1, "Buy Harrier - ", ""); //harrier
	initHShopItem("helicopter_flares", 500, 5, 2, "Buy Pavelow - ", ""); //pavelow

	initHShopItem("sentry", 450, 6, 0, "Buy Sentry - ", "");
	initHShopItem("helicopter_minigun", 800, 6, 1, "Buy Chopper - ", ""); //helicopter_minigun
	initHShopItem("ac130", 1000, 6, 2, "Buy AC-130 - ", "");

	initHShopItem("stealth_airstrike", 250, 7, 0, "Buy Stealth Bomber - ", ""); //stealthbomber
	initHShopItem("artillery", 400, 7, 1, "Buy Artillery Strike - ", "");
	initHShopItem("nuke", 3550, 7, 2, "Buy Nuke - ", "");

	initHShopItem("betterdevils", 500, 8, 0, "Buy Better Devils - ", "");
	initHShopItem("grimreaper", 500, 8, 1, "Buy Grimreaper - ", "");
}
getZItemVal(item_name, var){
	return self.ZMenu[item_name][var];
}
setZItemVal(item_name, var, value){
	self.Zmenu[item_name][var] = value;
}
getHItemVal(item_name, var){
	return self.HMenu[item_name][var];
}
setHItemVal(item_name, var, value){
	self.Hmenu[item_name][var] = value;
}
getCItemVal(item_name, var){
	return self.CMenu[item_name][var];
}
setCItemVal(item_name, var, value){
	self.Cmenu[item_name][var] = value;
}

doShop()
{
	self endon( "disconnect" );
	self endon( "game_ended" );

	self thread onGamestatechange();

	while( 1 )
	{
		self waittill ( "zmod_shop_change" );

		self notify ( "zmod_shop_close" );

		self iprintln( "Shop Change" );

		if( level.gameState == "intermission" )
		{
			self thread doCreditShop();
		}
		else
		{
			if( self.team == "axis" )
				self thread doZombieShop();
			else
				self thread doHumanShop();
		}
		self thread monitorShop();
	}
}

onGamestatechange()
{
	self endon( "disconnect" );
	self endon ( "game_ended" );

	while(1)
	{
		level waittill( "gamestatechange" );
		self notify( "zmod_shop_change" );
	}
}

doCreditShop()
{
	self endon("disconnect");
	self endon("death");
	self endon( "zmod_shop_close" );
	self notify("CASH"); //updates what currency to display

	self.shopname = "credit";
	self.menu = 0;
	self iprintln(self.shopname);

	self.numberOfPages = self.CArray.size-1;
	self startMenuListenEvents();

	while(1)
	{
		if( isAlive( self ) )
		{
			//new way of printing the menu; uses ZArray
			self.menutext setText("Credit Shop " + (self.menu+1) + "/" + self.numberOfPages);
			item0 = self.CArray[self.menu][0]; //returns "name" of the item
			item1 = self.CArray[self.menu][1];
			item2 = self.CArray[self.menu][2];
			self.option1 setText("Press [{+smoke}] - " + self getCItemVal(item0, self getCItemVal(item0,"print_text")));
			self.option2 setText("Press [{+actionslot 2}] - " + self getCItemVal(item1, self getCItemVal(item1,"print_text")));
			self.option3 setText("Press [{+actionslot 4}] - " + self getCItemVal(item2, self getCItemVal(item2,"print_text")));
			self.scrollright setText(">");
			self.scrollleft setText("<");
		}
		else
		{
			self.menutext setText( "" );
			self.option1 setText( "" );
			self.option2 setText( "" );
			self.option2 setText( "" );
			self.scrollright setText("");
			self.scrollleft setText("");
		}
			self waittill ( "zmod_shop_draw" );
	}
}


doZombieShop()
{
	self endon("disconnect");
	self endon("death");
	self endon( "zmod_shop_close" );

	self.shopname = "zombie";
	self.menu = 0;
	self iprintln(self.shopname);

	self.numberOfPages = self.ZArray.size-1;
	self startMenuListenEvents();

	while(1)
	{
		self.menutext setText("Zombie Shop " + (self.menu+1) + "/" + self.numberOfPages);
		//new way of printing the menu; uses ZArray
		item0 = self.ZArray[self.menu][0]; //returns "name" of the item
		item1 = self.ZArray[self.menu][1];
		item2 = self.ZArray[self.menu][2];
		self.option1 setText("Press [{+smoke}] - " + self getZItemVal(item0, self getZItemVal(item0,"print_text")));
		self.option2 setText("Press [{+actionslot 2}] - " + self getZItemVal(item1, self getZItemVal(item1,"print_text")));
		self.option3 setText("Press [{+actionslot 4}] - " + self getZItemVal(item2, self getZItemVal(item2,"print_text")));

		self waittill ( "zmod_shop_draw" );
	}
}

doHumanShop()
{
	self endon("disconnect");
	self endon("death");
	self endon( "zmod_shop_close" );
	self notify("CASH"); //updates what currency to display

	self.shopname = "human";
	self.menu = 0;
	self iprintln(self.shopname);

	self.numberOfPages = self.HArray.size-1;
	self startMenuListenEvents();

	while(1)
	{
		self.menutext setText("Human Shop " + (self.menu+1) + "/" + self.numberOfPages);
		item0 = self.HArray[self.menu][0]; //returns "name" of the item
		item1 = self.HArray[self.menu][1];
		item2 = self.HArray[self.menu][2];
		self.option1 setText("Press [{+smoke}] - " + self getHItemVal(item0, self getHItemVal(item0,"print_text")));
		self.option2 setText("Press [{+actionslot 2}] - " + self getHItemVal(item1, self getHItemVal(item1,"print_text")));
		self.option3 setText("Press [{+actionslot 4}] - " + self getHItemVal(item2, self getHItemVal(item2,"print_text")));

		self waittill ( "zmod_shop_draw" );
	}
}

selectShopOption( option )
{
	self endon ( "death" );
	self endon ( "zmod_shop_close" );

	if(!isDefined( option ))
		return;

	self iprintln ( "Menu Select: " + option);

	switch( self.shopname )
	{
		case "human":
			self [[level.HFuncArray[self.menu][option]]]();
		break;

		case "zombie":
			self [[level.ZFuncArray[self.menu][option]]]();
		break;

		case "credit":
			self [[level.CFuncArray[self.menu][option]]]();
		break;
	}

	self monitorShop();
}

/*
Monitors everything shop related; updates what text to print depending on currentweapon etc.
*/
monitorShop()
{
	if( self getCItemVal("tacticalinsertion", "in_use") == 1 )
	{
		self setCItemVal("tacticalinsertion", "print_text", "text2");
	}

	if(self getCItemVal("finalstand", "in_use")==1)
	{
		self setCItemVal("finalstand", "print_text", "text2");
	}

	if(self getCItemVal("finalstand", "in_use")==1)
	{
		self setCItemVal("finalstand", "print_text", "text2");
	}

	if(self getCItemVal("antialpha", "in_use")==1)
	{
		self setCItemVal("antialpha", "print_text", "text2");
	}
	else
	{
		self setCItemVal("antialpha", "print_text", "text1");
	}

	if(self getCItemVal("cash", "in_use")==1)
	{
		self setCItemVal("cash", "print_text", "text2");
	}

	/*Updates text to print for when akimbo is available/unavailable*/
	if(isAttachable("akimbo"))
		self setHItemVal("akimbo", "print_text", "text1");
	else
		self setHItemVal("akimbo", "print_text", "text2");

	if(self getHItemVal("sight", "in_use")==1)
	{
		self setHItemVal("sight", "print_text", "text2");
	}
	else
		self setHItemVal("sight", "print_text", "text1");

	/*Updates what text to print for all the weapon swapping "items", either "swap smg/ar/lmg/etc." or "exchange curr weapon for smg/ar/lmg"*/
	if(!(self getCurrentWeapon()=="none"))
	{ //makes sure to not change anything if current weapon is "none" (for example while climbing), so just keeps state from before player started climbing
		foreach(weaponclass in level.weaponclasses)
		{
			basename = strtok(weaponclass, "_");
			modweaponclass = getWeaponClass(self getCurrentWeapon());

			if(modweaponclass=="weapon_machine_pistol")
				modweaponclass="weapon_pistol";

			if(modweaponclass==weaponclass)
				self setHItemVal(basename[1], "print_text", "text2");

			else  self setHItemVal(basename[1], "print_text", "text1");
				self notify("MENUCHANGE_2");
		}
	}

	self notify( "zmod_shop_draw" );
}

scrollShopMenu( option )
{
	self iprintln ( "Menu Scroll: " + option);

	if( option == "+" )			//Forward
	{
		if( self.menu == self.numberOfPages - 1)
		{
			self.menu = 0;
		}
		else
		{
			self.menu++;
		}
	}
	else if( option == "-" )	//Back
	{
		if( self.menu == 0 )
		{
			self.menu = self.numberOfPages - 1;
		}
		else
		{
			self.menu--;
		}
	}

	self notify ( "zmod_shop_draw" );
}

clearOnDeath()
{
	while( 1 )
	{
		self waittill_either ( "death", "clearMenu");

		self.healthlabel setText( "" );
		self.healthtext setText( "" );
		self.lifelabel setText( "" );
		self.lifetext setText( "" );
		self.cashlabel SetText( "" );
		self.cash setText( "" );
		self.menutext SetText( "" );
		self.option1 SetText( "" );
		self.option2 SetText( "" );
		self.option3 SetText( "" );
		self.scrollleft SetText( "" );
		self.scrollright SetText( "" );
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
	self.buttonAction[7]="weapnext";
	self.buttonAction[8]="+activate";			//F
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

listenEvent(function, parameter, event, endon_event1, endon_event2)
{
	if(endon_event1 != 0)
		self endon (endon_event1);

	if(endon_event2 != 0)
		self endon (endon_event2);

	while(1)
	{
		self waittill(event);
		if(parameter != "")
		{
			self [[function]](parameter);
		}
		else
		{
			self [[function]]();
		}
	}
}

startMenuListenEvents()
{
	//self thread listenEvent(::ForgeSpawnCrate, 0, "+attack", "stopforge", "menuopen");
	self thread listenEvent(::scrollShopMenu, "+", "+actionslot 1", "death", "zmod_shop_close");
	self thread listenEvent(::scrollShopMenu, "-", "+actionslot 3", "death", "zmod_shop_close");

	self thread listenEvent(::selectShopOption, 0, "+smoke", "death", "zmod_shop_close");
	self thread listenEvent(::selectShopOption, 1, "+actionslot 2", "death", "zmod_shop_close");
	self thread listenEvent(::selectShopOption, 2, "+actionslot 4", "death", "zmod_shop_close");

	self thread listenEvent(::monitorWeaponSwap, "", "weapnext", "death", "disconnect");

	self thread listenEvent(maps\mp\gametypes\_credit_items::execTacticalInsertion, "", "+activate", "disconnect", "death");
}

monitorWeaponSwap(){
	currWeap = self getCurrentWeapon();
	while(currWeap==self getCurrentWeapon() || self getCurrentWeapon()=="none"){
		wait .2;
	}
	self thread monitorShop();
}
statCashAdd(amount)
{
  if (self.bounty + amount < 99999)
  self.bounty += amount;
  else
  self.bounty = 99999;
  self notify("CASH");
  self.cash maps\mp\gametypes\_zmod_hud::doTextPulse("cash");
}

statCashSub(amount)
{
  if (self.bounty - amount > 0)
  self.bounty -= amount;
  else
  self.bounty = 0;
  self notify("CASH");
  self.cash maps\mp\gametypes\_zmod_hud::doTextPulse("cash", 0.6);
}

statMaxHealthAdd(amount)
{
  self.maxhealth += amount;
  self.health += amount;
  self notify("HEALTH");
  self.healthtext maps\mp\gametypes\_zmod_hud::doTextPulse("health");
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
