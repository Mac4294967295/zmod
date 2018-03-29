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

	level.HFuncArray[4][0]=::steadyaim;
	level.HFuncArray[4][1]=::sleightofhand;
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

	initZShopItem("coldblood", 250, 1, 0, "Buy Coldblood - ", "^1Coldblood activated");
	initZShopItem("ninja", 100, 1, 1, "Buy Ninja - ", "^1Ninja activated");
	initZShopItem("movespeed", 50, 1, 2, "Buy Movespeed - ", "^1Max Movespeed achieved");

	initZShopItem("placeholder", 100, 2, 0, "Buy PLACEHOLDER - ", "^1PLACEHOLDER activated");
	initZShopItem("stinger", 150, 2, 1, "Buy Stinger - ", "^1Stinger equipped");
	initZShopItem("commando", 200, 2, 2, "Buy Commando - ", "^1Commando activated");

	initZShopItem("blastshield", 300, 3, 0, "Buy Blastshield - ", "^1Equip/Unequip Blastshield");
	initZShopItem("riotshield", 300, 3, 1, "Buy Riotshield - ", "^1 Riotshield equipped");
	initZShopItem("suicide", "", 3, 2, "Suicide", "");
}
initializeHMenu(){
	self.HMenu[100][7] = [];
	self.HArray[9][3] = []; //stores name of shop item in regard to position; is used for printing the menu
	initHShopItem("ammo", 100, 0, 0, "Buy Ammo - ", "^1current weapon ammo full");
	initHShopItem("extendedmags", 150, 0, 1, "Buy Extended Mags - ", "^1Extended Mags equipped");
	initHShopItem("sight", 50, 0, 2, "Unlock Sights - ", "Swap Sight");

	initHShopItem("smg", 100, 1, 0, "Exchange current weapon for SMG - ", "Swap SMG");
	initHShopItem("assault", 150, 1, 1, "Exchange current weapon for AR - ", "Swap AR");
	initHShopItem("lmg", 200, 1, 2, "Exchange current weapon for LMG - ", "Swap LMG");

	initHShopItem("pistol", 100, 2, 0, "Exchange current weapon for Pistol - ", "Swap Pistol");
	initHShopItem("shotgun", 150, 2, 1, "Exchange current weapon for Shotgun - ", "Swap Shotgun");
	initHShopItem("sniper", 200, 2, 2, "Exchange current weapon for Sniper - ", "Swap Sniper");

	initHShopItem("riotshield", 200, 3, 0, "Buy Riotshield - ", "^1Riotshield already equipped");
	initHShopItem("akimbo", 50, 3, 1, "Buy Akimbo - ", "^1Akimbo unavailable");
	initHShopItem("repair", 250, 3, 2, "Buy Repair Tool  - ", "^1Unavailable");

	initHShopItem("steadyaim", 100, 4, 0, "Buy Steady Aim - ", "^1Steady Aim equipped");
	initHShopItem("sleightofhand", 150, 4, 1, "Buy Sleight of Hand - ", "^1Sleight of Hand equipped");
	initHShopItem("rpg", 50, 4, 2, "Buy RPG - ", "^1Unavailable");

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

doShop(){
	if(level.showcreditshop){
		self thread doCreditShop();
	}else if(self.isZombie==0){
		self thread doHumanShop();
	}else self thread doZombieShop();
}

doCreditShop()
{
	self endon("disconnect");
	self endon("death");
	self notify("CASH"); //updates what currency to display
	numberOfPages = self.CArray.size-1;
	while(level.showcreditshop)
	{
		doMenuScroll(numberOfPages);
		//self.perkztext3 setText("Lives: "+self getCItemVal("life", "in_use") );
		//self.perkztext3.glowColor = ( 1, 0, 0 );
		//new way of printing the menu; uses ZArray
		self.menutext setText("Credit Shop " + (self.menu+1) + "/" + numberOfPages);
		item0 = self.CArray[self.menu][0]; //returns "name" of the item
		item1 = self.CArray[self.menu][1];
		item2 = self.CArray[self.menu][2];
		self.option1 setText("Press [{+smoke}] - " + self getCItemVal(item0, self getCItemVal(item0,"print_text")));
		self.option2 setText("Press [{+actionslot 2}] - " + self getCItemVal(item1, self getCItemVal(item1,"print_text")));
		self.option3 setText("Press [{+actionslot 4}] - " + self getCItemVal(item2, self getCItemVal(item2,"print_text")));
		if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
			self [[level.CFuncArray[self.menu][0]]]();
		}
		if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
			self [[level.CFuncArray[self.menu][1]]]();
		}
		if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
			self [[level.CFuncArray[self.menu][2]]]();
		}

		wait 0.1;
	}
	doHumanShop(); //at end of creditshop call humanshop
}


doZombieShop()
{
	self endon("disconnect");
	self endon("death");
	numberOfPages = self.ZArray.size-1;
	while(self.isZombie!=0)
	{
		doMenuScroll(numberOfPages);
		self.menutext setText("Zombie Shop " + (self.menu+1) + "/" + numberOfPages);
		self.perkztext3 setText("Movespeed: "+self.moveSpeedScaler+"x");
		self.perkztext3.glowColor = ( 1, 0, 0 );
		//new way of printing the menu; uses ZArray
		item0 = self.ZArray[self.menu][0]; //returns "name" of the item
		item1 = self.ZArray[self.menu][1];
		item2 = self.ZArray[self.menu][2];
		self.option1 setText("Press [{+smoke}] - " + self getZItemVal(item0, self getZItemVal(item0,"print_text")));
		self.option2 setText("Press [{+actionslot 2}] - " + self getZItemVal(item1, self getZItemVal(item1,"print_text")));
		self.option3 setText("Press [{+actionslot 4}] - " + self getZItemVal(item2, self getZItemVal(item2,"print_text")));




		if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
			self [[level.ZFuncArray[self.menu][0]]]();
		}
		if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
			self [[level.ZFuncArray[self.menu][1]]]();
		}
		if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
			self [[level.ZFuncArray[self.menu][2]]]();
		}

		wait 0.1;
	}
}

doHumanShop()
{
	self endon("disconnect");
	self endon("death");
	self notify("CASH"); //updates what currency to display
	numberOfPages = self.HArray.size-1;
	while(self.isZombie==0)
	{
		doMenuScroll(numberOfPages);
		self.menutext setText("Human Shop " + (self.menu+1) + "/" + numberOfPages);
		self.perkztext3 setText("");
		self.perkztext3.glowColor = ( 1, 0, 0 );
		item0 = self.HArray[self.menu][0]; //returns "name" of the item
		item1 = self.HArray[self.menu][1];
		item2 = self.HArray[self.menu][2];
		self.option1 setText("Press [{+smoke}] - " + self getHItemVal(item0, self getHItemVal(item0,"print_text")));
		self.option2 setText("Press [{+actionslot 2}] - " + self getHItemVal(item1, self getHItemVal(item1,"print_text")));
		self.option3 setText("Press [{+actionslot 4}] - " + self getHItemVal(item2, self getHItemVal(item2,"print_text")));



		if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
			self [[level.HFuncArray[self.menu][0]]]();
		}
		if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
			self [[level.HFuncArray[self.menu][1]]]();
		}
		if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
			self [[level.HFuncArray[self.menu][2]]]();
		}

		wait 0.1;
	}
}
/*
Monitors everything shop related; updates what text to print depending on currentweapon etc.
*/
monitorShop(){
	self endon("disconnect");
	self endon("death");
	while(1){
		if(self getCItemVal("tacticalinsertion", "in_use")==1){
			self setCItemVal("tacticalinsertion", "print_text", "text2");
		}
		if(self getCItemVal("finalstand", "in_use")==1){
			self setCItemVal("finalstand", "print_text", "text2");
		}
		if(self getCItemVal("finalstand", "in_use")==1){
			self setCItemVal("finalstand", "print_text", "text2");
		}
		if(self getCItemVal("antialpha", "in_use")==1){
			self setCItemVal("antialpha", "print_text", "text2");
		}
		if(self getCItemVal("cash", "in_use")==1){
			self setCItemVal("cash", "print_text", "text2");
		}
		wait 0.5;
	//	string="1";
	//	if(string=="1") string = tableLookup( "mp/statsTable.csv", 1, 3000, 0 );
	//	self iPrintlnBold(string);

		if(self getCurrentWeapon()!="usp_tactical_mp" && self getCurrentWeapon()!="riotshield_mp" && self.isZombie!=0){
			self takeAllWeapons();
			self giveWeapon("usp_tactical_mp", 0, false);
		  self setWeaponAmmoClip("usp_tactical_mp", 0);
		  self setWeaponAmmoStock("usp_tactical_mp", 0);
		  wait .2;
		  self switchToWeapon("usp_tactical_mp");
			if(self getZItemVal("riotshield", "in_use")==1){
				self giveWeapon("riotshield_mp", 0, false);
			}
		}
		/*
		Updates text to print for when akimbo is available/unavailable
		*/
		if(isAttachable("akimbo")) self setHItemVal("akimbo", "print_text", "text1");
		else self setHItemVal("akimbo", "print_text", "text2");

		if(self getHItemVal("sight", "in_use")==1){
			self setHItemVal("sight", "print_text", "text2");
		}
		else self setHItemVal("sight", "print_text", "text1");

		if(!(self getCurrentWeapon()=="none")){ //makes sure to not change anything if current weapon is "none" (for example while climbing), so just keeps state from before player started climbing
			foreach(weaponclass in level.weaponclasses){
			basename = strtok(weaponclass, "_");
			modweaponclass = getWeaponClass(self getCurrentWeapon());
			if(modweaponclass=="weapon_machine_pistol") modweaponclass="weapon_pistol";
				if(modweaponclass==weaponclass) self setHItemVal(basename[1], "print_text", "text2");
				else  self setHItemVal(basename[1], "print_text", "text1");
					self notify("MENUCHANGE_2");
			}
		}
	}
}

doMenuScroll(numberOfPages){
	if(self.menu==-1) self.menu=numberOfPages-1;
	if(self.menu==numberOfPages) self.menu=0;
	if(self.buttonPressed[ "+actionslot 3" ] == 1){
		self.buttonPressed[ "+actionslot 3" ] = 0;
		self.menu--;
	}
	if(self.menu==-1) self.menu=numberOfPages-1;
	if(self.menu==numberOfPages) self.menu=0;
	if(self.buttonPressed[ "+actionslot 1" ] == 1){
		self.buttonPressed[ "+actionslot 1" ] = 0;
		self.menu++;
	}
	if(self.menu==-1) self.menu=numberOfPages-1;
	if(self.menu==numberOfPages) self.menu=0;
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

destroyOnDeath()
{
	self endon("disconnect");
	while(1){
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
	  self.DebugHUD destroy();
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
