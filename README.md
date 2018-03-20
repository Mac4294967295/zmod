# zmod by Praetorian & Mac

# Instructions
I) Place the zmod folder in your mods folder located in your game root folder
II) run following command: fs_game mods/zmod; map *<MAP_NAME>*

# Map Names
- mp_afghan:		Afghan
- mp_derail:		Derail
- mp_estate:		Estate
- mp_favela:		Favela
- mp_highrise:		Highrise
- mp_invasion:		Invasion
- mp_checkpoint:	Karachi
- mp_quarry:		Quarry
- mp_rundown:		Rundown
- mp_rust:			Rust
- mp_boneyard:		Scrapyard
- mp_nightshift:	Skidrow
- mp_subbase:		Sub Base
- mp_terminal:		Terminal
- mp_underpass:		Underpass
- mp_brecourt:		Wasteland 
- mp_complex:		Bailout
- mp_crash:			Crash
- mp_compact:		Salvage
- mp_overgrown:		Overgrown
- mp_storm :		Storm
- mp_abandon 		Carnival 
- mp_fuel2:			Fuel
- mp_strike:		Strike
- mp_trailerpark:	Trailer Park
- mp_vacant:		Vacant

#structure of the mod
The main logic of the mod is located in the file zmod\maps\mp\gametypes\_rank.gsc
#Editing the mod
open the *.gsc files with your preferred text editor
## adding shop items
###I)
To add items to the shop initialize the item in the file zmod\maps\mp\gametypes\_shop_menu.gsc with the function *initShopItem(args)* and place it in the resetZMenu() function.
the arguments of the initShopItem(args) function are the following:
name:	the name of the item
cost: 	how much the item should cost
page: 	on which page the item should be displayed
pos: 	the position of the item on each page (0-2)
text1: 	the text which is displayed when the item is purchasable
text2: 	the text which is displayed when the item is not purchasable (e.g. when it's already bought)

####items additionally have the following attributes
in_use:		an integer which represents the current "in use" status of the item (default: 0)
print_text:	defines which text (either text1 or text2) should be displayed in the menu(values: "text1" or "text2")
###II)
add logic what should happen if the item is bought to the function doZombieShopPage*X*
###III)
add logic to function giveUpgrades() so the player gets his upgrades back on respawn