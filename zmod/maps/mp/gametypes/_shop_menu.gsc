

//HUDupdate();  updates HUD
foo(){
	self iPrintlnBold("testtesttest");
	self iPrintlnBold(self.ZMenu["movespeed"]["cost"]);
	self iPrintlnBold(self.ZMenu["movespeed"]["in_use"]);
}
/*
Initializes shop items:
name: reference to the item
every item has 7 variables: cost, page, pos, text1, text2, print_text, in_use
ZArray enables to find the name of a item directly by its page & pos in the shop; is used to print the menu
*/
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

/*
(re)sets the items and its variables
*/
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
/*
builds the array.
*/
initializeZMenu(){
	self.ZMenu[100][7] = [];
	self.ZArray[10][3] = []; //stores name of shop item in regard to position; is used for printing the menu
	resetZMenu();
}
