#include maps\mp\gametypes\_rank;
#include maps\mp\_utility;
#include maps\mp\gametypes\_shop_menu;

life(){
	if(self.credits >= self getCItemVal("life", "cost")){
		self maps\mp\gametypes\_zmod_gamelogic::statCreditsSub(self getCItemVal("life", "cost"));
		self setCItemVal("life", "in_use", self getCItemVal("life", "in_use")+1);
	}else self iPrintlnBold("^1Not Enough ^3Credits");
	self notify("MENUCHANGE_2");
	self notify("LIVES");
}

tacticalinsertion(){
	if(self.credits >= self getCItemVal("tacticalinsertion", "cost")){
		self maps\mp\gametypes\_zmod_gamelogic::statCreditsSub(self getCItemVal("tacticalinsertion", "cost"));
		self setCItemVal("tacticalinsertion", "in_use", 1);
		self takeWeapon("frag_grenade_mp");
		self SetOffhandPrimaryClass( "other" );
		self maps\mp\perks\_perkfunctions::setTacticalInsertion();
		self thread maps\mp\gametypes\_spawn::monitorTI();
	}else self iPrintlnBold("^1Not Enough ^3Credits");
	self notify("MENUCHANGE_2");
}

finalstand(){
	if(self.credits >= self getCItemVal("finalstand", "cost")){
		self maps\mp\gametypes\_zmod_gamelogic::statCreditsSub(self getCItemVal("finalstand", "cost"));
		self setCItemVal("finalstand", "in_use", 1);
		self maps\mp\perks\_perks::givePerk("specialty_finalstand");
	}else self iPrintlnBold("^1Not Enough ^3Credits");
	self notify("MENUCHANGE_2");
}

antialpha(){
	if(self.credits >= self getCItemVal("antialpha", "cost")){
		self maps\mp\gametypes\_zmod_gamelogic::statCreditsSub(self getCItemVal("antialpha", "cost"));
		self setCItemVal("antialpha", "in_use", 1);
	}else self iPrintlnBold("^1Not Enough ^3Credits");
	self notify("MENUCHANGE_2");
}

cash(){
	if(self.credits >= self getCItemVal("cash", "cost")){
		self maps\mp\gametypes\_zmod_gamelogic::statCreditsSub(self getCItemVal("cash", "cost"));
		self setCItemVal("cash", "in_use", 1);
		self.bounty=200;
	}else self iPrintlnBold("^1Not Enough ^3Credits");
	self notify("MENUCHANGE_2");
}

execTacticalInsertion()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "zmod_tacins_set" );

	/*
	self iprintln( "TacInsert" );
	self _giveWeapon( "flare_mp", 0 );
	self giveStartAmmo( "flare_mp" );
	wait 0.2;
	self switchToWeapon("flare_mp");
	self thread maps\mp\perks\_perkfunctions::monitorTIUse();
	wait 0.5;
	self notify( "grenade_fire", "lightstick", "flame_mp" );
	//self maps\mp\perks\_perkfunctions::setTacticalInsertion();
	*/
}




/*
gives the player the items on respawn
*/
giveCreditUpgrades()
{
	if(self getCItemVal("tacticalinsertion", "in_use") == 1 )
	{
		self takeWeapon("frag_grenade_mp");
		self SetOffhandPrimaryClass( "other" );
		self maps\mp\perks\_perkfunctions::setTacticalInsertion();
	}
	if( self getCItemVal("finalstand", "in_use") == 1 ){
		self maps\mp\perks\_perks::givePerk("specialty_finalstand");
	}
}
