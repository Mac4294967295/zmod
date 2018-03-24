#include maps\mp\gametypes\_rank;
#include maps\mp\_utility;
#include maps\mp\gametypes\_shop_menu;

life(){
	if(self.bounty >= self getCItemVal("life", "cost")){ 								
		self statCreditsSub(self getCItemVal("life", "cost"));
		self setCItemVal("life", "in_use", self getCItemVal("life", "in_use")+1);
	}else self iPrintlnBold("^1Not Enough ^3Cash");		
	self notify("MENUCHANGE_2");
}

tacticalinsertion(){
	if(self.bounty >= self getCItemVal("tacticalinsertion", "cost")){ 								
		self statCreditsSub(self getCItemVal("tacticalinsertion", "cost"));
		self setCItemVal("tacticalinsertion", "in_use", 1);
		self maps\mp\perks\_perkfunctions::setTacticalInsertion();
	}else self iPrintlnBold("^1Not Enough ^3Cash");		
	self notify("MENUCHANGE_2");
}

finalstand(){
	if(self.bounty >= self getCItemVal("finalstand", "cost")){ 								
		self statCreditsSub(self getCItemVal("finalstand", "cost"));
		self setCItemVal("finalstand", "in_use", 1);
		self maps\mp\perks\_perks::givePerk("specialty_finalstand");
	}else self iPrintlnBold("^1Not Enough ^3Cash");		
	self notify("MENUCHANGE_2");
}

antialpha(){
	if(self.bounty >= self getCItemVal("antialpha", "cost")){ 								
		self statCreditsSub(self getCItemVal("antialpha", "cost"));
		self setCItemVal("antialpha", "in_use", 1);
	}else self iPrintlnBold("^1Not Enough ^3Cash");		
	self notify("MENUCHANGE_2");
}

cash(){
	if(self.bounty >= self getCItemVal("cash", "cost")){ 								
		self statCreditsSub(self getCItemVal("cash", "cost"));
		self setCItemVal("cash", "in_use", 1);
	}else self iPrintlnBold("^1Not Enough ^3Cash");		
	self notify("MENUCHANGE_2");
}

/*
gives the player the items on respawn
*/
giveCashUpgrades(){
	if(getCItemVal("tacticalinsertion", "in_use")==1){
		self maps\mp\perks\_perkfunctions::setTacticalInsertion();
	}
}