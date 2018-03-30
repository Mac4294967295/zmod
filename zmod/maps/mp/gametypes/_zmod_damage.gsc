#include maps\mp\_utility;


GetModifiedDamage(iDamage, sWeapon, sHitLoc)
{
	damageMultiplier = 1;
	
	switch( sHitLoc )
	{
		case "helmet":
			damageMultiplier = 1.6;
			break;
		
		case "head":
			damageMultiplier = 1.6;
			break;
			
		case "neck":
			damageMultiplier = 1.4;
			break;
			
		case "torso_upper":
			damageMultiplier = 1.3;
			break;
			
		case "torso_lower":
			damageMultiplier = 0.9;
			break;
			
		case "right_arm_upper":
			damageMultiplier = 0.7;
			break;
			
		case "left_arm_upper":
			damageMultiplier = 0.7;
			break;
			
		case "right_arm_lower":
			damageMultiplier = 0.5;
			break;
			
		case "left_arm_lower":
			damageMultiplier = 0.5;
			break;
			
		case "right_hand":
			damageMultiplier = 0.3;
			break;
			
		case "left_hand":
			damageMultiplier = 0.3;
			break;
			
		case "gun":
			damageMultiplier = 0;
			break;
			
		case "right_leg_upper":
			damageMultiplier = 0.7;
			break;
			
		case "left_leg_upper":
			damageMultiplier = 0.7;
			break;
			
		case "right_leg_lower":
			damageMultiplier = 0.5;
			break;
			
		case "left_leg_lower":
			damageMultiplier = 0.5;
			break;
			
		case "right_foot":
			damageMultiplier = 0.3;
			break;
			
		case "left_foot":
			damageMultiplier = 0.3;
			break;
			
		default:
			damageMultiplier = 1;
			break;
	}


	//mp/statsTable.csv
	switch( getWeaponClass(sWeapon))
	{
		case "weapon_projectile":
			damageMultiplier = damageMultiplier * 3;
			break;	
			
		case "weapon_pistol":
			damageMultiplier = damageMultiplier * 1.1;
			break;			
		
		case "weapon_machine_pistol":
			damageMultiplier = damageMultiplier * 1.1;
			break;	
			
		case "weapon_shotgun":
			damageMultiplier = damageMultiplier * 1;
			break;

		case "weapon_assault":
			damageMultiplier = damageMultiplier * 1.2;
			break;

		case "weapon_lmg":
			damageMultiplier = damageMultiplier * 1.1;
			break;
			
		case "weapon_sniper":
			damageMultiplier = damageMultiplier * 2.2;
			break;			

		case "weapon_grenade":
			damageMultiplier = damageMultiplier * 3;
			break;				

		case "weapon_explosive":
			damageMultiplier = damageMultiplier * 3;
			break;				
				
		default: 
			break;
	}

	
	return int(iDamage * damageMultiplier);
}