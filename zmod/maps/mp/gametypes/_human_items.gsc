#include maps\mp\gametypes\_rank;
#include maps\mp\_utility;
#include maps\mp\gametypes\_shop_menu;

ammo(){
	if(self.bounty >= self getHItemVal("ammo", "cost")){
		self statCashSub(self getHItemVal("ammo", "cost"));
		foreach ( primary in self getWeaponsListPrimaries()){
			if(!isWeaponSpecial(primary)){ //makes sure to not give ammo for "special" weapons
				self GiveMaxAmmo(primary);
			}
		}
		//self.nades = getDefaultNadeAmmo(self.nadetype);
	}else self iPrintlnBold("^1Not Enough ^3Cash");
	self notify("MENUCHANGE_2");
}
extendedmags(){
	if (self getHItemVal("extendedmags", "in_use")==0){
		if (self.bounty >= self getHItemVal("extendedmags","cost")){
			self statCashSub(self getHItemVal("extendedmags","cost"));
			self setHItemVal("extendedmags", "in_use", 1);
			self setHItemVal("extendedmags", "print_text", "text2");
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

sight(){
	if(!isUsingKillstreak() &&!isWeaponSpecial(self getCurrentWeapon())){
		if(self getHItemVal("sight", "in_use")==0){
			if(self.bounty >= self getHItemVal("sight","cost")){
				self statCashSub(self getHItemVal("sight","cost"));
				self setHItemVal("sight", "in_use", 1);
				if((!isSubStr(self getCurrentWeapon(), "akimbo"))){ //only do something when weapon doesnt have akimbo currently
					upgradeWeaponSight();
				}
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}else{
			if(!isSubStr(self getCurrentWeapon(), "akimbo")){
																					//adds 1 to go to next sight


				upgradeWeaponSight();
			}
		}
	}
}

addSightToWeapon(sight){

}
smg(){
	exchangeWeapon("smg");
}

lmg(){
	exchangeWeapon("lmg");
}

assault(){
	exchangeWeapon("assault");
}

pistol(){
	exchangeWeapon("pistol");
}

shotgun(){
	exchangeWeapon("shotgun");
}

sniper(){
	exchangeWeapon("sniper");
}

hriotshield(){
	if(!isUsingKillstreak()){
		if (self getHItemVal("riotshield", "in_use")==0){
			if (self.bounty >= self getHItemVal("riotshield","cost")){
				self statCashSub(self getHItemVal("riotshield","cost"));
				self giveWeapon("riotshield_mp", 0, true);
				self switchToWeapon("riotshield_mp");
				self setHItemVal("riotshield", "in_use", 1);
				self setHItemVal("riotshield", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
	}
}

akimbo(){
	if(!isUsingKillstreak() && !isWeaponSpecial(self getCurrentWeapon())){
		if(isAttachable("akimbo")){
			if (self getHItemVal("akimbo", "in_use")==0){
				if (self.bounty >= self getHItemVal("akimbo","cost")){
					self statCashSub(self getHItemVal("akimbo","cost"));
					ammo = self GetWeaponAmmoStock(self getCurrentWeapon());
					basename = strtok(self getCurrentWeapon(), "_");
					gun = maps\mp\gametypes\_class::buildWeaponName(basename[0], self.attach1[self getCurrentWeapon()], "akimbo");
					self takeWeapon(self getCurrentWeapon());
					self giveWeapon(gun , 0, true);
					if(self getHItemVal("extendedmags", "in_use")==1){ //makes sure to give extended mags to new gun if xmags were acquired before
						weap = addXMagsToWeapon(gun);
						self switchToWeapon(weap);
						self SetWeaponAmmoStock( weap, ammo );
					}else{
						self switchToWeapon(gun);
						self SetWeaponAmmoStock( gun, ammo );
					}
				}
			}
		}
	}
}

repair(){
	if(!isUsingKillstreak()){
		if (self getHItemVal("repair", "in_use") <= 0){
			if (self.bounty >= self getHItemVal("repair", "cost")){
				self statCashSub(self getHItemVal("repair", "cost"));
				self setHItemVal("repair", "in_use", 15);
				self giveWeapon("defaultweapon_mp");
				self switchToWeapon("defaultweapon_mp");
				self setWeaponAmmoClip("defaultweapon_mp", 0);
				self setWeaponAmmoStock("defaultweapon_mp", 0);
				self thread monitorRepair();
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
	}
}

steadyaim(){
	if(self getHItemVal("steadyaim", "in_use")==0){
			if(self.bounty >= self getHItemVal("steadyaim", "cost")){
				self setHItemVal("steadyaim", "in_use", 1);
				self statCashSub(self getHItemVal("steadyaim", "cost"));
				self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
				self maps\mp\perks\_perks::givePerk("specialty_holdbreath");
				self setHItemVal("steadyaim", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
}

sleightofhand(){
	if(self getHItemVal("sleightofhand", "in_use")==0){
			if(self.bounty >= self getHItemVal("sleightofhand", "cost")){
				self setHItemVal("sleightofhand", "in_use", 1);
				self statCashSub(self getHItemVal("sleightofhand", "cost"));
				self maps\mp\perks\_perks::givePerk("specialty_fastreload");
				self maps\mp\perks\_perks::givePerk("specialty_quickdraw");
				self setHItemVal("sleightofhand", "print_text", "text2");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
}

rpg(){
	if(!isUsingKillstreak()){
		if(self getHItemVal("rpg", "in_use")==0){
			if(self.bounty >= self getHItemVal("rpg", "cost")){
				self setHItemVal("rpg", "in_use", 2);
				self statCashSub(self getHItemVal("rpg", "cost"));
				self setHItemVal("rpg", "print_text", "text2");
				self giveWeapon("rpg_mp", 0, true);
				self setWeaponAmmoStock("rpg_mp", 1);
				self switchToWeapon("rpg_mp");
				self thread monitorHWeaponAmmo("rpg");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
		}
		self notify("MENUCHANGE_2");
	}
}

predator_missile(){
	buyKillstreak("predator_missile", self getHItemVal("predator_missile", "cost"));
}

harrier_airstrike(){
	buyKillstreak("harrier_airstrike", self getHItemVal("harrier_airstrike", "cost"));
}

helicopter_flares(){
	buyKillstreak("helicopter_flares", self getHItemVal("helicopter_flares", "cost"));
}

sentry(){
	buyKillstreak("sentry", self getHItemVal("sentry", "cost"));
}

helicopter_minigun(){
	buyKillstreak("helicopter_minigun", self getHItemVal("helicopter_minigun", "cost"));
}

ac130(){
	buyKillstreak("ac130", self getHItemVal("ac130", "cost"));
}

nuke(){
	buyKillstreak("nuke", self getHItemVal("nuke", "cost"));
}



stealth_airstrike(){
	buyKillstreak("stealth_airstrike", self getHItemVal("stealth_airstrike", "cost"));
}

betterdevils(){
	self thread doBetterdevils();
}

grimreaper(){
	self thread doGrimreaper();
}
/*
.44 Magnum with explosive bullets
*/
doBetterdevils(){
	self endon("death");
	if(!isUsingKillstreak()){
		if (self.bounty >= self getHItemVal("betterdevils", "cost")){
			self statCashSub(self getHItemVal("betterdevils", "cost"));
			self setHItemVal("betterdevils", "in_use", 1);
			prevweapon = self GetCurrentWeapon(); 							//remembers what weapon player previously had
			hasAnaconda = self HasWeapon("coltanaconda_mp");
			anacondaAmmoStock = self getWeaponAmmoStock("coltanaconda_mp"); //keeps track of normal .44 ammo
			anacondaAmmoClip = self getWeaponAmmoClip("coltanaconda_mp");
			self giveWeapon("coltanaconda_mp", 0, true); 					//gives player a .44
			self setWeaponAmmoClip("coltanaconda_mp", 6);
			self setWeaponAmmoStock("coltanaconda_mp", 12);
			self switchToWeapon("coltanaconda_mp");
			ammoCount = 18;
			while(ammoCount>0){ 																						//tracks amount of shots fired
				self waittill ( "weapon_fired" );
				if(self GetCurrentWeapon()=="coltanaconda_mp"){ 														//makes sure player shot the .44 and not another gun
					forward = self getTagOrigin("j_head");
					end = self thread vector_scal(anglestoforward(self getPlayerAngles()),1000000);
					explosionLocation = BulletTrace( forward, end, 0, self )[ "position" ]; 							//tracks the explosion exposion should happen
					level.chopper_fx["explode"]["small"] = loadfx ("explosions/helicopter_explosion_secondary_small"); 	//creates a chopper explosion animation
					playfx(level.chopper_fx["explode"]["small"], explosionLocation);
					RadiusDamage( explosionLocation, 110, 1000, 200, self );												//specifies the radius, max damage, min damage, attacker
					ammoCount -= 1;
				}
			}
			self setHItemVal("betterdevils", "in_use", 0);
			self takeWeapon("coltanaconda_mp");
			if(hasAnaconda){
				self giveWeapon("coltanaconda_mp");								//if player previously had a .44, gives it back to him
				self setWeaponAmmoClip("coltanaconda_mp", anacondaAmmoClip);
				self setWeaponAmmoStock("coltanaconda_mp", anacondaAmmoStock);
			}
			self SwitchToWeapon(prevweapon);
			wait 0.2;
		}
	}
}

doGrimreaper(){
	self endon("death");
	if(!isUsingKillstreak()){
		if (self.bounty >= self getHItemVal("betterdevils", "cost")){
			self statCashSub(self getHItemVal("betterdevils", "cost"));
			self setHItemVal("grimreaper", "in_use", 1);
			prevweapon = self GetCurrentWeapon();

			//gives AT4, gives ammo in clip (chamber) and stock (reserve), switches to AT4
			self giveWeapon("at4_mp", 0, true);
			self setWeaponAmmoClip("at4_mp", 1);
			self setWeaponAmmoStock("at4_mp", 1);
			self switchToWeapon("at4_mp");

			//fires 4 shots, reloads, fires 4 shots
			self.rockets = 8;
			while(self.rockets > 0)
			{
				if(self.rockets == 5)
				{
					//no new ammunition after third shot, causing a reload on the fourth shot
					self waittill ("weapon_fired");
				}
				else if(self.rockets == 4)
				{
					//waiting for reload to end
					while(!(self getWeaponAmmoClip("at4_mp")))
					{
					wait 0.1;
					}
					//giving stock ammo before and giving clip and stock ammo after firing
					self setWeaponAmmoStock("at4_mp", 1);
					self waittill ("weapon_fired");
					self setWeaponAmmoStock("at4_mp", 1);
					self setWeaponAmmoClip("at4_mp", 1);
				}
				else
				{
					//giving stock and clip ammo after firing
					self waittill ("weapon_fired");
					self setWeaponAmmoStock("at4_mp", 1);
					self setWeaponAmmoClip("at4_mp", 1);
				}
				//causing a ac130_105mm_mp explosion at rocket destination
				if(self GetCurrentWeapon()=="at4_mp"){
					forward = self getTagOrigin("tag_weapon_left");
					end = self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
					location = BulletTrace( forward, end, 0, self )[ "position" ];
					MagicBullet( "ac130_105mm_mp", forward, location, self );
					self.rockets--;
				}
				wait  0.1;
			}
			//destroy self.rockets in case the for-loop exits prematurely
			self.rockets destroy();
			self setHItemVal("grimreaper", "in_use", 0);
			self SwitchToWeapon(prevweapon);
			wait 0.2;
			self takeWeapon("at4_mp");
		}
	}
}

artillery(){
	self endon("disconnect");
	self endon("death");
	if(!isUsingKillstreak()){
		if (self.bounty >= self getHItemVal("betterdevils", "cost")){
			self statCashSub(self getHItemVal("betterdevils", "cost"));
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
	}
}

/*
Upgrades current gun with next possible sight
*/
upgradeWeaponSight(){
	clip_ammo = self getWeaponAmmoClip(self getCurrentWeapon());
	stock_ammo = self getWeaponAmmoStock(self getCurrentWeapon());
	indexOfSight = 0;
	for(indexOfSight=0;indexOfSight<level.sights.size;indexOfSight++){				//sets indexOfSight to current sight index in level.sights[]
		if(isSubStr(self getCurrentWeapon(), level.sights[indexOfSight])) break;
	}
	indexOfSight++;
	for(i=0;i<level.sights.size;i++){
		indexOfSight = indexOfSight%level.sights.size;								//loops back to start of array if end is reached
		basename = strtok(self getCurrentWeapon(), "_");
		sight = level.sights[indexOfSight];											//name of sight which will be appended to the weapon name
		if(sight!="") sight=sight+"_";
		if(isDefined( level.weaponRefs[basename[0]+"_"+sight+"mp"] )){				//checks if sight is mountable on gun
			basename = strtok(self getCurrentWeapon(), "_");
			gun = basename[0]+"_"+sight+"mp";
			self takeWeapon(self getCurrentWeapon());
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
			break;
		}
		indexOfSight++;
	}
}

addXMagsToWeapon(weapon){

	if(!isUsingKillstreak() && !isWeaponSpecial(weapon)){
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
		//self takeWeapon(weapon);
		//self giveWeapon(gun, 0, true);
		//self setWeaponAmmoStock(gun, ammo);
		//return gun;
	}
}




monitorHWeaponAmmo(weapon)
{
	self endon("disconnect");
	self endon("death");
	prevWeapon = self getCurrentWeapon();
	while(self getHItemVal(weapon, "in_use")>0)
	{
		self setHItemVal(weapon, "in_use", self getWeaponAmmoClip(weapon+"_mp") + self getWeaponAmmoStock(weapon+"_mp"));
		//self waittill ("weapon_fired");
		wait 0.1;
		self notify("MENUCHANGE_2");
	}
	self setHItemVal(weapon, "in_use", 0);
	self takeWeapon(weapon+"_mp");
	self switchToWeapon(prevWeapon);
	self setHItemVal(weapon, "print_text", "text1");
}

killstreakUsePressed(item, cost)
{
	streakName = item;
	lifeId = -1;

//	assert( isDefined( streakName ) );
//	assert( isDefined( level.killstreakFuncs[ streakName ] ) );

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

	if ( !self common_scripts\utility::isWeaponEnabled() )
		return ( 8 );

	if ( !self [[ level.killstreakFuncs[ streakName ] ]]( lifeId ) )
		return ( 9 );

	self statCashSub(cost);
	return ( 0 );
}

isUsingKillstreak(){

	if ( self isUsingRemote() )
		return true;

	if ( isDefined( self.selectingLocation ) )
		return true;
	if(self IsUsingTurret()) return true;
	return false;
}
buyKillstreak(item, cost){
	if (self.bounty >= cost) self thread killstreakUsePressed(item, cost);
	else self iPrintlnBold("^1Not Enough ^3Cash");
}

/*
Updates the isRepairing boolean; signals if player is currently able to repair (has repair tool as weapon and has "ammo" left in the tool
*/
monitorRepair(){
	self endon("disconnect");
	self endon("death");
	prevWeapon = self getCurrentWeapon();
	while(1){
		if(self getHItemVal("repair", "in_use") > 0){
			if (self getCurrentWeapon() == "defaultweapon_mp") self.isRepairing = true;
			else self.isRepairing = false;

		}else{
			//wait 1.3;
			self.isRepairing=false;
			self takeWeapon("defaultweapon_mp");
			self switchToWeapon(prevWeapon);
			break;
		}
		wait 1.3;
	}
}



/*
gives the player the next possible weapon in the specified weaponclass
*/
exchangeWeapon(weaponclass){
																				//makes sure to not be able to swap weapon while one of the "special" weapons is equipped
	if(!isWeaponSpecial(self getCurrentWeapon()) && !isUsingKillstreak()){
		//self iPrintLnBold("curr weap is not spec");
		weaponClassArray = getWeaponArr(weaponclass); 							//array of basenames of guns of class weaponclass
		modweaponclass = getWeaponClass(self getCurrentWeapon());
		if(modweaponclass=="weapon_machine_pistol") modweaponclass="weapon_pistol";
		if(modweaponclass!="weapon_"+weaponclass){
			if(self.bounty >= self getHItemVal(weaponclass, "cost")){
				self statCashSub(self getHItemVal(weaponclass, "cost"));
				rand = randomInt(weaponClassArray.size); 						//number representing index of weapon in weaponClassArray
				randWeapon = weaponClassArray[rand];
																				//makes sure to not give a weapon which the player already has
				while(isSubStr(self getWeaponsListPrimaries()[0], randWeapon) || isSubStr(self getWeaponsListPrimaries()[1], randWeapon) || isSubStr(self getWeaponsListPrimaries()[2], randWeapon)){
					rand = (rand+1)%weaponClassArray.size;
					randWeapon = weaponClassArray[rand];
				}
				randWeapon = weaponClassArray[rand];
				self setHItemVal(weaponclass, "in_use", 1);
				self setHItemVal(weaponclass, "print_text", "text2");
				self takeWeapon(self getCurrentWeapon());
				self giveWeapon(randWeapon + "_mp", 0, true); 					//gives player the weapon
				self GiveMaxAmmo(randWeapon + "_mp"); 							//gives full ammo for new weapon
				if(self getHItemVal("extendedmags", "in_use")==1){ 				//makes sure to give extended mags to new gun if xmags were acquired before
					weap = addXMagsToWeapon(randWeapon + "_mp");
					self switchToWeapon(weap);
				}else self switchToWeapon(randWeapon + "_mp");
			}else self iPrintlnBold("^1Not Enough ^3Cash");
			self notify("MENUCHANGE_2");
		}else{
			i = 0;
			while(1){															//returns index in weaponClassArray of current weapon
				basename = strtok(self getCurrentWeapon(), "_");
				if(basename[0]==weaponClassArray[i]) break;
				i++;
			}
			//self iPrintLnBold("currWeap: "+weaponClassArray[i]);
			clip_ammo_ratio = self getWeaponAmmoClip(self getCurrentWeapon())/weaponclipsize(self getCurrentWeapon());
			stock_ammo_ratio = self getWeaponAmmoStock(self getCurrentWeapon())/weaponmaxammo(self getCurrentWeapon());
			//makes sure to not give player a weapon he already has
			for(j=0;j<weaponClassArray.size;j++){
				boolean = true;
				foreach(weapon in self getWeaponsListPrimaries()){
					if(isSubStr(weapon, weaponClassArray[i])){
						boolean = false;
					}
				}
				if(boolean){
					break;
				}else{
					i=(i+1)%weaponClassArray.size;
				}
			}
			self takeWeapon(self getCurrentWeapon());
			if(self getHItemVal("extendedmags", "in_use")==1){					//makes sure to give extended mags to new gun if xmags were acquired before
				weap = addXMagsToWeapon(weaponClassArray[i] + "_mp");

			}else{
				weap = weaponClassArray[i] + "_mp";
			}
			self giveWeapon(weap, 0, true);
			self switchToWeapon(weap);
			self SetWeaponAmmoClip( weap, int(clip_ammo_ratio*weaponclipsize(weap)));
			self SetWeaponAmmoStock( weap, int(stock_ammo_ratio*weaponmaxammo(weap)));
		}
	}
}

getWeaponArr(weaponclass){
	weaponArray = [];
	switch(weaponclass){
		case "pistol": weaponArray = level.hand;
		break;

		case "smg": weaponArray = level.smg;
		break;

		case "assault": weaponArray = level.assault;
		break;

		case "projectile": weaponArray = level.explosives;
		break;

		case "sniper": weaponArray = level.rifle;
		break;

		case "shotgun": weaponArray = level.shot;
		break;

		case "lmg": weaponArray = level.lmg;
		break;

		default:
		break;
	}
	return weaponArray;
}



	/*
	switch( weaponclass )
	{
		case "weapon_pistol":
		case "weapon_smg":
		case "weapon_assault":
		case "weapon_projectile":
		case "weapon_sniper":
		case "weapon_shotgun":
		case "weapon_lmg":

			break;
		case "weapon_grenade":
		case "weapon_explosive":

			break;
		default:
			break;
	}*/
/*
returns true if the current weapon is a "special" weapon (betterdevils,grimreaper, rpg, riotshield)
*/
isWeaponSpecial(weapon){
	return
	((self getHItemVal("betterdevils", "in_use")!=0 && weapon=="coltanaconda_mp") ||
	(self getHItemVal("rpg", "in_use")!=0 && weapon=="rpg_mp") ||
	(self getHItemVal("grimreaper", "in_use")!=0 && weapon=="at4_mp") ||
	weapon=="riotshield_mp"||
	(self getHItemVal("repair", "in_use")!=0 && weapon =="defaultweapon_mp"));
}
/*
Returns whether the attachment is attachble on the current weapon
*/
isAttachable(attachment){
	if(isSubStr(self getCurrentWeapon(), attachment)) return false;
	basename = strtok(self getCurrentWeapon(), "_");
	if(basename.size>3) return false;
	if(basename.size==2){
		newWeaponName=basename[0]+"_"+attachment+"_mp";
	}else{
		newWeaponName=maps\mp\gametypes\_class::buildWeaponName(basename[0], basename[1], attachment);
	}
	return maps\mp\gametypes\_class::isValidWeapon(newWeaponName);
}

vector_scal(vec, scale)
{
  vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
  return vec;
}
