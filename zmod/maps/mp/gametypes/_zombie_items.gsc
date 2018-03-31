#include maps\mp\gametypes\_rank;
#include maps\mp\_utility;
#include maps\mp\gametypes\_shop_menu;
health(){
	if(self.maxhealth < 1000){ 																	//max health threshold
		if(self.bounty >= self getZItemVal("health", "cost")){ 								//check if enough cash
			self setZItemVal("health", "in_use", self getZItemVal("health", "in_use")+1); 	//signals how much health has been acquired
			self statMaxHealthAdd(50); 														//adds 50 health (max & current)
			self statCashSub(self getZItemVal("health", "cost"));							//subtracts the cost form current cash
			self iPrintlnBold("^2Health Increased!"); 										//prints text
			if(self getZItemVal("health", "in_use")==18) self setZItemVal("health", "print_text", "text2");			//at Max rank update what to print in the menu
		}else self iPrintlnBold("^1Not Enough ^3Cash");
	}
	self notify("MENUCHANGE_2");
}

wallhack(){
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

throwingknife(){
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

coldblood(){
	if(self getZItemVal("coldblood", "in_use")==0){
			if(self.bounty >= self getZItemVal("coldblood", "cost")){
				self setZItemVal("coldblood", "in_use", 1);
				self statCashSub(self getZItemVal("coldblood", "cost"));
				self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
				self maps\mp\perks\_perks::givePerk("specialty_spygame");
				self setZItemVal("coldblood", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
}

ninja(){
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

movespeed(){
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

stinger(){
	if (self getZItemVal("stinger", "in_use")==0){
			if (self.bounty >= self getZItemVal("stinger", "cost")){
				self statCashSub(self getZItemVal("stinger", "cost"));
				self giveWeapon("stinger_mp", 0, false);
				self switchToWeapon("stinger_mp");
				self GiveStartAmmo("stinger_mp");
				self setZItemVal("stinger", "in_use", 2);
				self thread monitorZWeaponAmmo("stinger");
				self switchToWeapon("stinger_mp");
				self setZItemVal("stinger", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
}

commando(){
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

blastshield(){
	if(self getZItemVal("blastshield", "in_use")==1) self maps\mp\perks\_perkfunctions::toggleBlastShield(self _hasPerk("_specialty_blastshield"));
		else if (self.bounty >= self getZItemVal("blastshield", "cost")){
			self statCashSub(self getZItemVal("blastshield", "cost"));
			self setZItemVal("blastshield", "in_use", 1);
			self maps\mp\perks\_perkfunctions::toggleBlastShield(false);
			self maps\mp\perks\_perks::givePerk("specialty_blastshield");
			self maps\mp\perks\_perkfunctions::toggleBlastShield(true);
			self maps\mp\perks\_perkfunctions::toggleBlastShield(self _hasPerk("_specialty_blastshield"));
			self setZItemVal("blastshield", "print_text", "text2");
			self iPrintlnBold("^2Bought Blast Shield!");
		}else self iPrintlnBold("^1Not Enough ^3Cash");
		self notify("MENUCHANGE_2");
}

zriotshield(){
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

giveZUpgrades(){ //gives the player the upgrades which he acquired through the shop + default perks (on respawn)

	self.maxhealth = 200+self getZItemVal("health", "in_use")*50;
	self.health = self.maxhealth;
	self notify("HEALTH");

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
		self maps\mp\perks\_perkfunctions::toggleBlastShield(self _hasPerk("_specialty_blastshield"));
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
		self thread monitorZWeaponAmmo("stinger");
		break;
		case 2:
		self giveWeapon("stinger_mp", 0, false);
		self setWeaponAmmoClip("stinger_mp", 1);
		self setWeaponAmmoStock("stinger_mp", 1);
		self thread monitorZWeaponAmmo("stinger");
		break;
		default:
		break;
	}

	self setZItemVal("riotshield", "in_use", 0);
	self setZItemVal("riotshield", "print_text", "text1");

	if(self getZItemVal("wallhack", "in_use")==1){
		self ThermalVisionFOFOverlayOn();
	}

	self notify("MENUCHANGE_2");
}

monitorZWeaponAmmo(weapon)
{
	self endon("disconnect");
	self endon("death");
	prevWeapon = self getCurrentWeapon();
	while(self getZItemVal(weapon, "in_use")>0)
	{
		self setZItemVal(weapon, "in_use", self getWeaponAmmoClip(weapon+"_mp") + self getWeaponAmmoStock(weapon+"_mp"));
		self waittill ("weapon_fired");
		wait 0.1;
		self notify("MENUCHANGE_2");
	}
	self setZItemVal(weapon, "in_use", 0);
	self takeWeapon(weapon+"_mp");
	self switchToWeapon(prevWeapon);
	self setZItemVal(weapon, "print_text", "text1");
}

monitorThrowingKnife()
{
	self endon("disconnect");
	self endon("death");
	while(self getZItemVal("throwingknife", "in_use")>0)
	{
		self setZItemVal("throwingknife", "in_use", self getWeaponAmmoClip("throwingknife_mp"));
		wait 0.1;
		self notify("MENUCHANGE_2");
	}
	self setZItemVal("throwingknife", "print_text", "text1");
}
