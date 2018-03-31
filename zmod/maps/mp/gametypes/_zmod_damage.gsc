#include maps\mp\_utility;

//Returns the modified base damage of a weapon
GetModifiedAttackerDamage(iDamage, sWeapon, sHitLoc)
{
	//Killstreaks
	switch(sWeapon)
	{
		case "ac130_105mm_mp":
			return int(iDamage * 0.6);
			
		case "ac130_40mm_mp":
			return int(iDamage * 0.8);

		case "ac130_25mm_mp":
			return int(iDamage * 0.2);
			
		case "remotemissile_projectile_mp":
			if(sHitLoc == "shield")
				return int(iDamage * 4);
			return int(iDamage * 1);

		case "cobra_player_minigun_mp":
			return int(iDamage * 1.5);

		case "sentry_minigun_mp":
			return int(iDamage * 0.8);
		
		case "harrier_20mm_mp":
			return int(iDamage * 1);
		
		case "pavelow_minigun_mp":
			return int(iDamage * 1.4);
			
		default:
			break;
	}					
	
	//Player Explosives Balancing
	switch(sWeapon)
	{
		case "rpg_mp":
			if(sHitLoc == "none")
				return int(iDamage * 3);
			if(sHitLoc == "shield")
				return int(iDamage * 2);
			return int(iDamage * 0.8);

		case "at4_mp":
			return int(iDamage * 1);
			
		case "frag_grenade_mp":
			if(sHitLoc == "none")
				return int(iDamage * 2.5);		
			if(sHitLoc == "shield")
				return int(iDamage * 1);
			return int(iDamage * 1);
			
		case "semtex_mp":
			if(sHitLoc == "none")
				return int(iDamage * 3);	
			if(sHitLoc == "shield")
				return int(iDamage * 6);
			return int(iDamage * 1);			
			
		case "claymore_mp":
			if(sHitLoc == "none")
				return int(iDamage * 4);	
			if(sHitLoc == "shield")
				return int(iDamage * 4);
			return int(iDamage * 1);		

		case "c4_mp":
			if(sHitLoc == "none")
				return int(iDamage * 4);	
			if(sHitLoc == "shield")
				return int(iDamage * 2);
			return int(iDamage * 1);			
			
		default:
			break;
	}		
	
	//Sniper Balancing
	if(getWeaponClass(sWeapon) == "weapon_sniper")
	{
		switch(sWeapon)
		{
			case "cheytac_mp":
				iDamage = int(iDamage * 1.6);
				break;	
			
			case "barrett_mp":
				iDamage = int(iDamage * 1.4);
				break;
			
			case "wa2000_mp":
				iDamage = int(iDamage * 1.2);
				break;	

			case "m21_mp":
				iDamage = int(iDamage * 1);
				break;	
		}
	}

	//Shotgun Balancing
	if(getWeaponClass(sWeapon) == "weapon_shotgun")
	{
		switch(sWeapon)
		{
			case "ranger_mp":
				return int(iDamage * 0.7);	
			
			case "model1887_mp":
				return int(iDamage * 1);	
			
			case "striker_mp":
				return int(iDamage * 1.3);		

			case "aa12_mp":
				return int(iDamage * 0.8);	

			case "m1014_mp":
				return int(iDamage * 1);		

			case "spas12_mp":
				return int(iDamage * 1.1);					
		}
	}
	
	//Hitlocation Mulipliers for Player Weapons
	switch( sHitLoc )
	{
		case "helmet":
			damageMultiplier = 1.2;
			break;
		
		case "head":
			damageMultiplier = 1.2;
			break;
			
		case "neck":
			damageMultiplier = 1.2;
			break;
			
		case "torso_upper":
			damageMultiplier = 1.2;
			break;
			
		case "torso_lower":
			damageMultiplier = 1.1;
			break;
			
		case "right_arm_upper":
			damageMultiplier = 0.9;
			break;
			
		case "left_arm_upper":
			damageMultiplier = 0.9;
			break;
			
		case "right_arm_lower":
			damageMultiplier = 0.7;
			break;
			
		case "left_arm_lower":
			damageMultiplier = 0.7;
			break;
			
		case "right_hand":
			damageMultiplier = 0.5;
			break;
			
		case "left_hand":
			damageMultiplier = 0.5;
			break;
			
		case "right_leg_upper":
			damageMultiplier = 0.9;
			break;
			
		case "left_leg_upper":
			damageMultiplier = 0.9;
			break;
			
		case "right_leg_lower":
			damageMultiplier = 0.7;
			break;
			
		case "left_leg_lower":
			damageMultiplier = 0.7;
			break;
			
		case "right_foot":
			damageMultiplier = 0.5;
			break;
			
		case "left_foot":
			damageMultiplier = 0.5;
			break;
		
		case "none":
			damageMultiplier = 1;
			break;

		case "shield":
			damageMultiplier = 1;
			break;
			
		default:
			damageMultiplier = 0;
			break;
	}


	//WeaponClass Table: mp/statsTable.csv
	//WeaponClass Multipliers
	switch( getWeaponClass(sWeapon))
	{
		case "weapon_projectile":
			break;	
			
		case "weapon_pistol":
			damageMultiplier = damageMultiplier * 1;
			break;			
		
		case "weapon_machine_pistol":
			damageMultiplier = damageMultiplier * 0.7;
			break;	

		case "weapon_smg":
			damageMultiplier = damageMultiplier * 0.7;
			break;	
			
		case "weapon_shotgun":
			//damageMultiplier = damageMultiplier * 1;
			break;

		case "weapon_assault":
			damageMultiplier = damageMultiplier * 0.8;
			break;

		case "weapon_lmg":
			damageMultiplier = damageMultiplier * 0.8;
			break;
			
		case "weapon_sniper":
			damageMultiplier = damageMultiplier * 1;
			break;			

		case "weapon_grenade":
			break;				

		case "weapon_explosive":
			break;				
				
		default: 
			break;
	}
	
	return int(iDamage * damageMultiplier);
}


//Modifies the damage based on victim specs
GetModifiedVictimDamage(victim, sMeansOfDeath, damage)
{
	if ( isPrimaryDamage( sMeansOfDeath ) && sMeansOfDeath != "MOD_EXPLOSIVE_BULLET")
	{	

	}
	else if ( isExplosiveDamage( sMeansOfDeath ) || sMeansOfDeath == "MOD_EXPLOSIVE_BULLET")
	{
		if ( victim _hasPerk( "_specialty_blastshield" ) )
			damage = int(damage * 0.5);
	}
	else if (sMeansOfDeath == "MOD_FALLING")
	{
		if ( victim _hasPerk( "specialty_falldamage" ) )
		{	
			damage = 0;
		}
	}
	
	return damage;
}