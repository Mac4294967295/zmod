#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init(){
	game["menu_stats"] = "stats";
	precacheMenu(game["menu_stats"]);
	level thread onPlayerConnect();
	level.stats = [];
	stats\_statsinit::initializeStats();
	//logstats();
	level thread test();
	level thread periodicalLog();
	wait 20;

	logstats();
}

onPlayerConnect()
{
    for(;;){
        level waittill("connected", player);
				player thread playerInitStats();
				player thread testprint("openMenu");
				player openMenu(game["menu_stats"]);

    }
}
/*reads data from _statsinit.gsc, the py script writes to said file*/
initPlayerData(xuid, name, HKills, ZKills, HAssists, ZAssists, HDeaths, ZDeaths, HTime, ZTime, score){
  level.stats[xuid]["name"] = name;
  level.stats[xuid]["HKills"] = HKills;
  level.stats[xuid]["ZKills"] = ZKills;
  level.stats[xuid]["HAssists"] = HAssists;
  level.stats[xuid]["ZAssists"] = ZAssists;
	level.stats[xuid]["HDeaths"] = HDeaths;
	level.stats[xuid]["ZDeaths"] = ZDeaths;
  level.stats[xuid]["HTime"] = HTime;
  level.stats[xuid]["ZTime"] = ZTime;
  level.stats[xuid]["score"] = score;
}

logstats(){
	xuids = getArrayKeys(level.stats); // get an array of the strings used to index
	logPrint("*******************STATSSTART*******************\n");
	for(i=0;i<xuids.size; i++){
		printString = "*STATS: "+xuids[i]+",";
		statNames = getArrayKeys(level.stats[xuids[0]]);
  	for(j=0;j<statNames.size;j++){
			if(j==statNames.size-1) printString+=level.stats[xuids[i]][statNames[j]];
			else printString+=level.stats[xuids[i]][statNames[j]]+",";
		}
		printString+="\n";
		logPrint(printString);
	}
}

test(){
	while(true){
		foreach(player in level.players){
			//player iPrintLnBold(player.ZAssists+" "+player.HAssits);
			player iPrintLnBold("eser");
			//player iPrintLnBold(player.isZombie+" "+level.gamestate+" HKills: "+player.HKills+" ZKills: "+player.ZKills+" HDeaths: "+player.HDeaths+" ZDeaths: "+player.ZDeaths);
		}
		updateDvars();
		wait 1;
	}
}

playerInitStats(){
	self setClientDvar("ui_showStats", 1);
	sortedXuids = getSortedXuids();
	i = 1;
	foreach(xuid in sortedXuids){
		if(i>10 || i>=sortedXuids.size) break;
		self setClientDvar("stats_name_"+i, level.stats[xuid]["name"]);
		self setClientDvar("stats_HKills_"+i, level.stats[xuid]["HKills"]);
		self setClientDvar("stats_HDeaths_"+i, level.stats[xuid]["HDeaths"]);
		self setClientDvar("stats_ZKills_"+i, level.stats[xuid]["ZKills"]);
		self setClientDvar("stats_ZDeaths_"+i, level.stats[xuid]["ZDeaths"]);
		self setClientDvar("stats_time_"+i, level.stats[xuid]["HTime"]);
		self setClientDvar("stats_score_"+i, level.stats[xuid]["score"]);
		i++;
	}
	self.HKills=0;
	self.ZKills=0;
	self.HDeaths=0;
	self.ZDeaths=0;
	self.HAssists=0;
	self.ZAssists=0;
	self.HTime=0;
	self.ZTime=0;
	self.zscore=0;
	level.stats[self.guid]["name"] = self.name;
	level.stats[self.guid]["HKills"] = self.HKills;
	level.stats[self.guid]["ZKills"] = self.ZKills;
	level.stats[self.guid]["HAssists"] = self.HAssists;
	level.stats[self.guid]["ZAssists"] = self.ZAssists;
	level.stats[self.guid]["HDeaths"] = self.HDeaths;
	level.stats[self.guid]["ZDeaths"] = self.ZDeaths;
	level.stats[self.guid]["HTime"] = self.HTime;
	level.stats[self.guid]["ZTime"] = self.ZTime;
	level.stats[self.guid]["score"] = self.zscore;
}
/*Return the xuids sorted by their score; xuid at index 0=best player*/
getSortedXuids(){
	xuids = getArrayKeys(level.stats);
	for(i=0;i<xuids.size; i++){
		for(j=i+1;j<xuids.size; j++){
			if(level.stats[xuids[i]]["score"]>level.stats[xuids[j]]["score"]){
				temp = xuids[i];
				xuids[i] = xuids[j];
				xuids[j] = temp;
			}
		}
	}
	return xuids;
}
updateStatsArray(){
	foreach(player in level.players){
		level.stats[player.guid]["name"] = player.name;
	  level.stats[player.guid]["HKills"] += player.HKills;
		player.HKills=0;
	  level.stats[player.guid]["ZKills"] += player.ZKills;
		player.ZKills=0;
	  level.stats[player.guid]["HAssists"] += player.HAssists;
		player.HAssists=0;
	  level.stats[player.guid]["ZAssists"] += player.ZAssists;
		player.ZAssists=0;
		level.stats[player.guid]["HDeaths"] += player.HDeaths;
		player.HDeaths=0;
		level.stats[player.guid]["ZDeaths"] += player.ZDeaths;
		player.ZDeaths=0;
	  level.stats[player.guid]["HTime"] += player.HTime;
		player.HTime=0;
	  level.stats[player.guid]["ZTime"] += player.ZTime;
		player.ZTime=0;
	  level.stats[player.guid]["score"] += player.zscore;
		player.zscore=0;
	}
}

periodicalLog(){
	while(true){
		updateStatsArray();
		logStats();
		wait 10;
	}
}
updateDvars(){
	while(true){
		sortedXuids = getSortedXuids();
		foreach(player in level.players){
			player setClientDvar("ui_showStats", 1);

			i = 1;
			foreach(xuid in sortedXuids){
				if(i>10 || i>=sortedXuids.size) break;
				player setClientDvar("stats_name_"+i, level.stats[xuid]["name"]);
				player setClientDvar("stats_HKills_"+i, level.stats[xuid]["HKills"]);
				player setClientDvar("stats_HDeaths_"+i, level.stats[xuid]["HDeaths"]);
				player setClientDvar("stats_ZKills_"+i, level.stats[xuid]["ZKills"]);
				player setClientDvar("stats_ZDeaths_"+i, level.stats[xuid]["ZDeaths"]);
				player setClientDvar("stats_time_"+i, level.stats[xuid]["HTime"]);
				player setClientDvar("stats_score_"+i, level.stats[xuid]["score"]);
				i++;
			}
		}
		wait 1;
	}
}

testprint(text){
	while(true){
		self iPrintLnBold(text);
		//self closeMenus();
		//self closepopupMenu();
		//self closeInGameMenu();
		wait .5;
		//self openMenu(game["menu_stats"]);
		wait 1;
	}

}
