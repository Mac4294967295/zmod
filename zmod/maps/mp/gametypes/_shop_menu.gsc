#include maps\mp\gametypes\_rank;
#include maps\mp\_utility;
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
}

/*
(re)sets the items and its variables
*/
resetZMenu(){
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
resetHMenu(){
	initHShopItem("ammo", 100, 0, 0, "Buy Ammo - ", "^1current weapon ammo full");
	initHShopItem("smg", 150, 0, 1, "Exchange current weapon for SMG - ", "Swap SMG");
	initHShopItem("riotshield", 200, 0, 2, "Buy Riotshield - ", "^1Riotshield already equipped");
	
	initHShopItem("akimbo", 50, 1, 0, "Buy Akimbo - ", "^1Akimbo unavailable");
	initHShopItem("empty2", 100, 1, 1, "PLAcEHOLDER ", "^");
	initHShopItem("sight", 50, 1, 2, "Unlock Sights - ", "^1Swap Sight");
	
	initHShopItem("empty3", 200, 2, 0, "PLACEHOLDER", "");
	initHShopItem("extendedmags", 150, 2, 1, "Buy Extended Mags - ", "^1Extended Mags equipped");
	initHShopItem("empty0", 50, 2, 2, "Buy PLACEHOLDER - ", "");
	
	initHShopItem("steadyaim", 100, 3, 0, "Buy Steady Aim - ", "^1Steady Aim equipped");	
	initHShopItem("sleightofhand", 150, 3, 1, "Buy Sleight of Hand - ", "^1Sleight of Hand equipped");
	initHShopItem("rpg", 50, 3, 2, "Buy RPG - ", "^1Unavailable");
	
	initHShopItem("empty1", 200, 4, 0, "PLACEHOLDER", "");
	initHShopItem("acog", 50, 4, 1, "Buy ACOG - ", "^1Unavailable");
	initHShopItem("predator", 150, 4, 2, "Buy Predator - ", "");
	
	initHShopItem("nuke", 3550, 5, 0, "Buy Nuke - ", "");
	initHShopItem("sniper", 100, 5, 1, "Buy Sniper Rifle - ", "^1Unavailable");
	initHShopItem("ac130", 1000, 5, 2, "Buy AC-130 - ", "");
	
	initHShopItem("sentry", 450, 6, 0, "Buy Sentry - ", "");
	initHShopItem("pavelow", 500, 6, 1, "Buy Pavelow - ", "");
	initHShopItem("chopper", 800, 6, 2, "Buy Chopper - ", "");
	
	initHShopItem("harrier", 450, 7, 0, "Buy Harrier - ", "");
	initHShopItem("repair", 250, 7, 1, "Buy Repair Tool  - ", "^1Unavailable");
	initHShopItem("betterdevils", 500, 7, 2, "Buy Better Devils - ", "");
	
	initHShopItem("artillery", 400, 8, 0, "Buy Artillery Strike - ", "");
	initHShopItem("stealthbomber", 250, 8, 1, "Buy Stealth Bomber - ", "");
	initHShopItem("grimreaper", 500, 8, 2, "Buy Grimreaper - ", "");
}
/*
builds the array.
*/
initializeZMenu(){
	self.ZMenu[100][7] = [];
	self.ZArray[10][3] = []; //stores name of shop item in regard to position; is used for printing the menu
	resetZMenu();
}
initializeHMenu(){
	self.HMenu[100][7] = [];
	self.HArray[10][3] = []; //stores name of shop item in regard to position; is used for printing the menu
	resetHMenu();
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


giveZUpgrades(){ //gives the player the upgrades which he acquired through the shop + default perks (on respawn)
	self _clearPerks();
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	self maps\mp\perks\_perks::givePerk("specialty_thermal");
	if(self getZItemVal("health", "in_use")>0){
		self.maxhealth = self.maxhp;
		self.health = self.maxhp;
		self notify("HEALTH");
	}
	if(self getZItemVal("movespeed", "in_use")>0){
		self.moveSpeedScaler = 1.0+self getZItemVal("movespeed", "in_use")*0.1;
		self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
	}else{
		self.moveSpeedScaler = 1;
		self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
	}
	if(self getZItemVal("coldblood", "in_use")>0){
		self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
		self maps\mp\perks\_perks::givePerk("specialty_spygame");
	}
	if(self getZItemVal("ninja", "in_use")>0){
		self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
		self maps\mp\perks\_perks::givePerk("specialty_quieter");
	}
	if(self getZItemVal("commando", "in_use")>0){
		self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
		self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	}
	
	if (self getZItemVal("blastshield", "in_use")==1)
	{
		self maps\mp\perks\_perks::givePerk("specialty_blastshield");
	}
	
	if(self getZItemVal("throwingknife", "in_use")>0)
	{
		self maps\mp\perks\_perks::givePerk( "throwingknife_mp" );
		self setWeaponAmmoClip("throwingknife_mp", 1);
		self thread monitorThrowingKnife();
	}
	
	switch(self getZItemVal("stinger", "in_use"))
	{
		case 1:
		self giveWeapon("stinger_mp", 0, false);
		self setWeaponAmmoClip("stinger_mp", 1);
		self setWeaponAmmoStock("stinger_mp", 0);
		self thread monitorStinger();
		break;
		case 2:
		self giveWeapon("stinger_mp", 0, false);
		self setWeaponAmmoClip("stinger_mp", 1);
		self setWeaponAmmoStock("stinger_mp", 1);
		self thread monitorStinger();
		break;
		default:
		break;
	}
	
	if(self getZItemVal("riotshield", "in_use")==1){
		self giveWeapon("riotshield_mp", 0, false);
	}
	
	if(self getZItemVal("wallhack", "in_use")==1){
		self ThermalVisionFOFOverlayOn();
	}
	
	self notify("MENUCHANGE_2");
}
doZombieShopPage0(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){ 													//do on button press
		self.buttonPressed[ "+smoke" ] = 0;														//"releases" pressed button
		if(self.maxhp < 1000){ 																	//max health threshold
			if(self.bounty >= self getZItemVal("health", "cost")){ 								//check if enough cash
				self setZItemVal("health", "in_use", self getZItemVal("health", "in_use")+1); 	//signals how much health has been acquired
				self statMaxHealthAdd(50); 														//adds 50 health (max & current)
				self statCashSub(self getZItemVal("health", "cost"));							//subtracts the cost form current cash
				self iPrintlnBold("^2Health Increased!"); 										//prints text
				if(self.maxhp==1000) self setZItemVal("health", "print_text", "text2");			//at Max rank update what to print in the menu
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");		
	}
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		if(self getZItemVal("wallhack", "in_use")==0){
			if (self.bounty >= self getZItemVal("wallhack", "cost")){
				self statCashSub(self getZItemVal("wallhack", "cost"));
				self ThermalVisionFOFOverlayOn();
				self setZItemVal("wallhack", "in_use", 1);
				self iPrintlnBold("^2Wallhack Activated!");
				self setZItemVal("wallhack", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
	}
	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		if(self getZItemVal("throwingknife", "in_use")==0){
			if(self.bounty >= self getZItemVal("throwingknife", "cost")){
				self statCashSub(self getZItemVal("throwingknife","cost"));
				self setZItemVal("throwingknife", "in_use", 1);
				self thread monitorThrowingKnife();
				self maps\mp\perks\_perks::givePerk( "throwingknife_mp" );
				self setWeaponAmmoClip("throwingknife_mp", 1);
				self setZItemVal("throwingknife", "in_use", 1);
				self iPrintlnBold("^2Throwing Knife Purchased");
				self setZItemVal("throwingknife", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
	}
}

doZombieShopPage1(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
		if(self getZItemVal("coldblood", "in_use")==0){
			if(self.bounty >= self getZItemVal("coldblood", "cost")){
				self setZItemVal("coldblood", "in_use", 1);
				self statCashSub(self getZItemVal("coldblood", "cost"));
				self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
				self maps\mp\perks\_perks::givePerk("specialty_spygame");
				self iPrintlnBold("^2Coldblood bought!");
				self setZItemVal("coldblood", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
	}
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		if(self getZItemVal("ninja", "in_use")==0){
			if(self.bounty >= self getZItemVal("ninja", "cost")){
				self statCashSub(self getZItemVal("ninja", "cost"));
				self setZItemVal("ninja", "in_use", 1);
				self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
				self maps\mp\perks\_perks::givePerk("specialty_quieter");
				self iPrintlnBold("^2Ninja bought!");
				self setZItemVal("ninja", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
	}
	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		if(self getZItemVal("movespeed", "in_use")<5){ //allows a max of 5 movespeed upgrades
			if(self.bounty >= self getZItemVal("movespeed", "cost")){
				statCashSub(self getZItemVal("movespeed", "cost"));
				self setZItemVal("movespeed", "in_use", getZItemVal("movespeed", "in_use")+1);						
				self.moveSpeedScaler += 0.1;
				self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
				self iPrintlnBold("^2Speed Bought!");
				if(self getZItemVal("movespeed", "in_use")==5){
					self setZItemVal("movespeed", "print_text", "text2");
				}
			}else self iPrintlnBold("^1Not Enough ^3Cash");		
		}
		self notify("MENUCHANGE_2");
	}
}

doZombieShopPage2(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){			//PLACEHOLDER (not assigned
		self.buttonPressed[ "+smoke" ] = 0;
		
	}
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		if (self getZItemVal("stinger", "in_use")==0){
			if (self.bounty >= self getZItemVal("stinger", "cost")){
				self statCashSub(self getZItemVal("stinger", "cost"));
				self giveWeapon("stinger_mp", 0, false);
				self switchToWeapon("stinger_mp");
				self GiveStartAmmo("stinger_mp");
				self setZItemVal("stinger", "in_use", 2);
				self thread monitorStinger();
				self iPrintlnBold("^2Bought Stinger!");
				self setZItemVal("stinger", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");	
		}
		self notify("MENUCHANGE_2");
	}
	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		if(self getZItemVal("commando", "in_use")==0){
			if(self.bounty >= self getZItemVal("commando", "cost")){
				self statCashSub(self getZItemVal("commando", "cost"));
				self setZItemVal("commando", "in_use", 1);
				self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
				self maps\mp\perks\_perks::givePerk("specialty_falldamage");
				self iPrintlnBold("^2Commando bought!");
				self setZItemVal("commando", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
	}
}

doZombieShopPage3(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
		if(self getZItemVal("blastshield", "in_use")==1) self maps\mp\perks\_perkfunctions::toggleBlastShield(self _hasPerk("_specialty_blastshield"));
		else if (self.bounty >= self getZItemVal("blastshield", "cost")){
			self statCashSub(self getZItemVal("blastshield", "cost"));
			self setZItemVal("blastshield", "in_use", 1);
			self maps\mp\perks\_perkfunctions::toggleBlastShield(false);
			self maps\mp\perks\_perks::givePerk("specialty_blastshield");
			self maps\mp\perks\_perkfunctions::toggleBlastShield(true);
			self setZItemVal("blastshield", "print_text", "text2");
			self iPrintlnBold("^2Bought Blast Shield!");
		}else self iPrintlnBold("^1Not Enough ^3Cash");
		self notify("MENUCHANGE_2");
	}
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		if (self getZItemVal("riotshield", "in_use")==0){
			if (self.bounty >= self getZItemVal("riotshield","cost")){
				self statCashSub(self getZItemVal("riotshield","cost"));
				self giveWeapon("riotshield_mp", 0, false);
				self switchToWeapon("riotshield_mp");
				self setZItemVal("riotshield", "in_use", 1);
				self setZItemVal("riotshield", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
	}
	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		self suicide();
		self notify("MENUCHANGE_2");
	}
}
doZombieShop()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		switch(self.menu){
			case 0:
			doZombieShopPage0();
			break;
			case 1:
			doZombieShopPage1();
			break;
			case 2:
			doZombieShopPage2();
			break;
			case 3:
			doZombieShopPage3();
			break;
			default:
			break;
		}
		wait 0.1;
	}
}

doHumanShop()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		switch(self.menu){
			case 0:
			doHumanShopPage0();
			break;
			case 1:
			doHumanShopPage1();
			break;
			case 2:
			doHumanShopPage2();
			break;
			case 3:
			doHumanShopPage3();
			break;
			case 4:
			doHumanShopPage4();
			break;
			case 5:
			doHumanShopPage5();
			break;
			case 6:
			doHumanShopPage6();
			break;
			case 7:
			doHumanShopPage7();
			break;
			case 8:
			doHumanShopPage8();
			break;
			default:
			break;
		}
		wait 0.1;
	}
}

doHumanShopPage0(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){ 													
		self.buttonPressed[ "+smoke" ] = 0;																													
		if(self.bounty >= self getHItemVal("ammo", "cost")){ 								
			self statCashSub(self getHItemVal("ammo", "cost"));
			foreach ( primary in self getWeaponsListPrimaries()){
				if(!((primary=="coltanaconda_mp" && self getZItemVal("betterdevils", "in_use")==1) || primary=="at4_mp" || primary=="rpg_mp")){
					self GiveMaxAmmo(primary);
				}
			}
		self.nades = getDefaultNadeAmmo(self.nadetype);
		}else self iPrintlnBold("^1Not Enough ^3Cash");		
		self notify("MENUCHANGE_2");		
	}
	
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		if(!((self getHItemVal("betterdevils")==1 && self getCurrentWeapon()=="coltanaconda_mp") || (self getHItemVal("rpg")==1 && self getCurrentWeapon()=="rpg_mp") || (self getHItemVal("grimreaper")==1 && self getCurrentWeapon()=="at4_mp") || self getCurrentWeapon()=="riotshield_mp")){ //makes sure to not be able to swap weapon while one of the "special" weapons is equipped
			if(getWeaponClass(self getCurrentWeapon())!="weapon_smg"){
				if(self.bounty >= self getHItemVal("smg", "cost")){
					self statCashSub(self getHItemVal("smg", "cost"));
					self.randomsmg = randomInt(level.smg.size);
					while(isSubStr(self getWeaponsListPrimaries()[0], level.smg[self.randomsmg]) || isSubStr(self getWeaponsListPrimaries()[1], level.smg[self.randomsmg]) || isSubStr(self getWeaponsListPrimaries()[2], level.smg[self.randomsmg])){ //makes sure to not give a weapon which the player already has
						self.randomsmg = (self.randomsmg+1)%level.smg.size;
					}
					self setHItemVal("smg", "in_use", 1);
					self setHItemVal("smg", "print_text", "text2");
					self takeWeapon(self getCurrentWeapon());
					self giveWeapon(level.smg[self.randomsmg] + "_mp", 0, false); 	//gives player the weapon
					self GiveMaxAmmo(level.smg[self.randomsmg] + "_mp"); 			//gives full ammo for new weapon
					//self switchToWeapon(level.smg[self.randomsmg] + "_mp");
					
					
					if(self getHItemVal("extendedmags", "in_use")==1){
						weap = addXMagsToWeapon(level.smg[self.randomsmg] + "_mp");
						self switchToWeapon(weap);
						//self SetWeaponAmmoClip( weap, clip_ammo );
						
					}else self switchToWeapon(level.smg[self.randomsmg] + "_mp");
					//	self SetWeaponAmmoClip( gun, clip_ammo );
						
				}else self iPrintlnBold("^1Not Enough ^3Cash");
				self notify("MENUCHANGE_2");
			}else{
				i = 0;
				while(1){														//returns index in level.smg of current weapon
					basename = strtok(self getCurrentWeapon(), "_");
					if(basename[0]==level.smg[i]) break;
					i++;
				}
				clip_ammo = self getWeaponAmmoClip(self getCurrentWeapon());
				stock_ammo = self getWeaponAmmoStock(self getCurrentWeapon());
				while(isSubStr(self getWeaponsListPrimaries()[0], level.smg[i]) || isSubStr(self getWeaponsListPrimaries()[1], level.smg[i]) || isSubStr(self getWeaponsListPrimaries()[2], level.smg[i])){ //makes sure to not give player a weapon he already has
					i = (i+1)%level.smg.size;
				}
				self takeWeapon(self getCurrentWeapon());
				//self giveWeapon(level.smg[i] + "_mp", 0, false);
				//self setWeaponAmmoClip(level.smg[i] + "_mp", clip_ammo);
				//self setWeaponAmmoStock(level.smg[i] + "_mp", stock_ammo);
				//self switchToWeapon(level.smg[i] + "_mp");
				
				
				if(self getHItemVal("extendedmags", "in_use")==1){
					weap = addXMagsToWeapon(level.smg[i] + "_mp");
					self giveWeapon(weap, 0, false);
					self switchToWeapon(weap);
					self SetWeaponAmmoClip( weap, clip_ammo );
					self SetWeaponAmmoStock( weap, stock_ammo );
				}else{
					self giveWeapon(level.smg[i] + "_mp", 0, false);
					self switchToWeapon(level.smg[i] + "_mp");
					self SetWeaponAmmoClip( level.smg[i] + "_mp", clip_ammo );
					self SetWeaponAmmoStock( level.smg[i] + "_mp", stock_ammo );
				}
			}
		}
	}

	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		if (self getHItemVal("riotshield", "in_use")==0){
			if (self.bounty >= self getHItemVal("riotshield","cost")){
				self statCashSub(self getHItemVal("riotshield","cost"));
				self giveWeapon("riotshield_mp", 0, false);
				self switchToWeapon("riotshield_mp");
				self setHItemVal("riotshield", "in_use", 1);
				self setHItemVal("riotshield", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
	}
}

doHumanShopPage1(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
		if(self.attach["akimbo"] == 1){
			if (self getHItemVal("akimbo", "in_use")==0){
				if (self.bounty >= self getHItemVal("akimbo","cost")){
					self statCashSub(self getHItemVal("akimbo","cost"));
					ammo = self GetWeaponAmmoStock(self.current);
					basename = strtok(self.current, "_");
					gun = buildWeaponName(basename[0], self.attach1[self.currentweapon], "akimbo");
					self takeWeapon(self.current);
					self giveWeapon(gun , 0, true);
					//self SetWeaponAmmoStock( gun, ammo );
					//self switchToWeapon(gun);
					
					if(self getHItemVal("extendedmags", "in_use")==1){
						weap = addXMagsToWeapon(gun);
						self switchToWeapon(weap);
						//self SetWeaponAmmoClip( weap, clip_ammo );
						self SetWeaponAmmoStock( weap, ammo );
					}else{
						self switchToWeapon(gun);
					//	self SetWeaponAmmoClip( gun, clip_ammo );
						self SetWeaponAmmoStock( gun, ammo );
					}
				}
			}
		}
	}
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		
	}
	
	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		if(self getHItemVal("sight", "in_use")==0){
			if(self.bounty >= self getHItemVal("sight","cost")){
				self statCashSub(self getHItemVal("sight","cost"));
				self setHItemVal("sight", "in_use", 1);
				if((!isSubStr(self getCurrentWeapon(), "akimbo")) && self.attach["reflex"]==1){ //only do something when weapon doesnt have akimbo currently
					upgradeWeaponSight("reflex");
				}
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}else{
			if(!isSubStr(self getCurrentWeapon(), "akimbo")){
				for(i=0;i<level.sights.size;i++){
					if(isSubStr(self getCurrentWeapon(), level.sights[i%level.sights.size])){
						basename = strtok(self.current, "_");
						if(i+1==3){
							upgradeWeaponSight("");
							/*
							clip_ammo = self getWeaponAmmoClip(self getCurrentWeapon());
							stock_ammo = self getWeaponAmmoStock(self getCurrentWeapon());
							self takeWeapon(self.current);
							gun = basename[0]+"_mp";
							self giveWeapon(gun , 0, true);
							self SetWeaponAmmoClip( gun, clip_ammo );
							self SetWeaponAmmoStock( gun, stock_ammo );
							self switchToWeapon(gun);
							*/
							break;
						}
						if(isDefined( level.weaponRefs[basename[0]+"_"+level.sights[(i+1)%level.sights.size]+"_mp"] )){			
							upgradeWeaponSight(level.sights[(i+1)%level.sights.size]);
							break;
						}
					}
				}
			}
		}
	}
}
/*
Upgrades current gun with sight 
*/
upgradeWeaponSight(sight){
	clip_ammo = self getWeaponAmmoClip(self getCurrentWeapon());
	stock_ammo = self getWeaponAmmoStock(self getCurrentWeapon());
	if(sight!="") sight = sight+"_";
	basename = strtok(self.current, "_");
	gun = basename[0]+"_"+sight+"mp";
	self takeWeapon(self.current);
	self giveWeapon(gun , 0, true);
	if(self getHItemVal("extendedmags", "in_use")==1){
		weap = addXMagsToWeapon(gun);
		self switchToWeapon(weap);
		self SetWeaponAmmoClip( weap, clip_ammo );
		self SetWeaponAmmoStock( weap, stock_ammo );
	}else{
		self switchToWeapon(gun);
		self SetWeaponAmmoClip( gun, clip_ammo );
		self SetWeaponAmmoStock( gun, stock_ammo );
	}
}

addXMagsToWeapon(weapon){
	
	ammo = self GetWeaponAmmoStock(weapon);
	basename = strtok(weapon, "_");
	gun="";
	for(i=0;i<basename.size-1;i++){
		gun=gun+basename[i]+"_";
	}
	gun = gun+"xmags_mp";
	if(isDefined(level.weaponRefs[gun])){
		self takeWeapon(weapon);
	self giveWeapon(gun, 0, true);
	self setWeaponAmmoStock(gun, ammo);
	return gun;
	}else{
		return weapon;
	}
	//self iPrintlnBold(weapon);
	self takeWeapon(weapon);
	self giveWeapon(gun, 0, true);
	self setWeaponAmmoStock(gun, ammo);
	return gun;
}

doHumanShopPage2(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
		
	}
	
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		if (self getHItemVal("extendedmags", "in_use")==0){
			if (self.bounty >= self getHItemVal("extendedmags","cost")){
				self statCashSub(self getHItemVal("extendedmags","cost"));
				self setHItemVal("extendedmags", "in_use", 1);
				basename = strtok(self getCurrentWeapon(), "_");
				foreach(weapon in self getWeaponsListPrimaries()){
					string = addXMagsToWeapon(weapon);
					if(isSubStr(string, basename[0])){
						self switchToWeapon(string);
					}
				}	
			}
		}
	}
	
	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		
	}
}

doHumanShopPage3(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
		
	}
	
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		
	}
	
	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		
	}
}

doHumanShopPage4(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
		
	}
	
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		
	}
	
	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		
	}
}

doHumanShopPage5(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
		
	}
	
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		
	}
	
	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		
	}
}

doHumanShopPage6(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
		
	}
	
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		
	}
	
	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		
	}
}

doHumanShopPage7(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
		
	}
	
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		
	}
	
	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		
	}
}

doHumanShopPage8(){
	//button 0
	if(self.buttonPressed[ "+smoke" ] == 1){
		self.buttonPressed[ "+smoke" ] = 0;
		
	}
	
	//button 1
	if(self.buttonPressed[ "+actionslot 2" ] == 1){
		self.buttonPressed[ "+actionslot 2" ] = 0;
		
	}
	
	//button 2
	if(self.buttonPressed[ "+actionslot 4" ] == 1){
		self.buttonPressed[ "+actionslot 4" ] = 0;
		
	}
}
/*
	Notifies the menu to updat when weapon is swapped
*/
