

//HUDupdate();  updates HUD
foo(){
	self iPrintlnBold("testtesttest");
	self iPrintlnBold(self.ZMenu["movespeed"]["cost"]);
	self iPrintlnBold(self.ZMenu["movespeed"]["in_use"]);
}
initShopItem(name, cost, page, pos, text1, text2){
	self.ZMenu[name]["cost"] = cost;
	self.ZMenu[name]["page"] = page;
	self.ZMenu[name]["pos"] = pos;
	self.ZMenu[name]["text1"] = text1;
	self.ZMenu[name]["text2"] = text2;
	self.ZMenu[name]["print_text"] = text1;
	self.ZMenu[name]["in_use"] = 0;
	self.ZArray[page][pos] = name;
}


resetZMenu(){
	initShopItem("health", 50, 0, 0, "Buy Health - 50", "^1Max Health achieved");
	initShopItem("wallhack", 200, 0, 1, "Buy Wallhack - 200", "^1Wallhack activated");
	initShopItem("throwingknife", 300, 0, 2, "Buy a Throwing Knife - 300", "^1Throwing Knife equipped");
	
	initShopItem("coldblood", 250, 1, 0, "Buy Coldblood - 250", "^1Coldblood activated");
	initShopItem("ninja", 100, 1, 1, "Buy Ninja - 100", "^1Ninja activated");
	initShopItem("movespeed", 50, 1, 2, "Buy Movespeed - 50", "^1Max Movespeed achieved");
	
	initShopItem("placeholder", 100, 2, 0, "Buy PLACEHOLDER - 250", "^1PLACEHOLDER activated");
	initShopItem("stinger", 150, 2, 1, "Buy Stinger - 150", "^1Stinger equipped");
	initShopItem("commando", 200, 2, 2, "Buy Commando - 200", "^1Commando activated");
	
	initShopItem("blastshield", 300, 3, 0, "Buy Blastshield - 300", "^1Equip/Unequip Blastshield");
	initShopItem("riotshield", 300, 3, 1, "Buy Riotshield - 300", "^1 Riotshield equipped");
	initShopItem("suicide", 0, 3, 2, "Suicide", "");
}
initializeZMenu(){
	//self iPrintlnBold("testtesttesttest");
	self.ZMenu[100][7] = [];
	self.ZArray[10][3] = []; //stores name of shop item in regard to position; is used for printing the menu
	resetZMenu();
}


/*
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
					self.option3 setText("Press [{+actionslot 4}] - " + level.zombieM[self.menu][2]);
				}else
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
							if (!self.blastshield) self.option1 setText("Press [{+smoke}] - " + level.zombieM[self.menu][0]);
							else self.option1 setText("Press [{+smoke}] - Equip/Unequip Blastshield");
							if (self.riotz){
								if (self hasWeapon("riotshield_mp")) self.option2 setText("Unavailable");
								else self.option2 setText("Press [{+actionslot 2}] - " + level.zombieM[self.menu][1]);
							}else self.option2 setText("[Locked]");
								
							self.option3 setText("Press [{+actionslot 4}] - " + level.zombieM[self.menu][2]);
							
						}
			}
			else
				{
					self.option1 setText("Press [{+smoke}] - " + level.zombieM[self.menu][0]);
					self.option2 setText("Press [{+actionslot 2}] - " + level.zombieM[self.menu][1]);
					self.option3 setText("Press [{+actionslot 4}] - " + level.zombieM[self.menu][2]);
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
	level.itemCost["Commando"] = 200;
	level.itemCost["StoppingPower"] = 200;
	level.itemCost["StoppingPowerPro"] = 50;
	level.itemCost["ColdBlooded"] = 250;
	level.itemCost["ColdBloodedPro"] = 100;
	level.itemCost["Ninja"] = 100;
	level.itemCost["NinjaPro"] = 100;
	level.itemCost["Movespeed"] = 100;
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



MenuInit()
{

	
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
	level.zombieM[i][2]["normal"] = "Buy Movespeed - " + level.itemCost["Movespeed"];
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
}
*/
