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
	level thread periodicalLog();
	logstats();
	thread updateDvars();
}

onPlayerConnect()
{
    for(;;){
        level waittill("connected", player);
				player thread playerInitStats();
				//player openMenu(game["menu_stats"]);
				player thread monitorTime();
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
/*prints all player stats to games_mp.log*/
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
/*initializes and sets the stats to 0 for a new player*/
playerInitStats(){
	self setClientDvar("ui_showStats", 1);
	self setClientDvar("ui_showSelfStat", 0);
	if(!isDefined(level.stats[self.guid]["name"])) level.stats[self.guid]["name"] = self.name;
	if(!isDefined(level.stats[self.guid]["HKills"])) level.stats[self.guid]["HKills"] = 0;
	if(!isDefined(level.stats[self.guid]["ZKills"])) level.stats[self.guid]["ZKills"] = 0;
	if(!isDefined(level.stats[self.guid]["HAssists"])) level.stats[self.guid]["HAssists"] = 0;
	if(!isDefined(level.stats[self.guid]["ZAssists"])) level.stats[self.guid]["ZAssists"] = 0;
	if(!isDefined(level.stats[self.guid]["HDeaths"])) level.stats[self.guid]["HDeaths"] = 0;
	if(!isDefined(level.stats[self.guid]["ZDeaths"])) level.stats[self.guid]["ZDeaths"] = 0;
	if(!isDefined(level.stats[self.guid]["HTime"])) level.stats[self.guid]["HTime"] = 0;
	if(!isDefined(level.stats[self.guid]["ZTime"])) level.stats[self.guid]["ZTime"] = 0;
	if(!isDefined(level.stats[self.guid]["score"])) level.stats[self.guid]["score"] = 0;

}
/*Return the xuids sorted by their score; xuid at index 0=highest score*/
getSortedXuids(){
	xuids = getArrayKeys(level.stats);
	for(i=0;i<xuids.size; i++){
		for(j=i+1;j<xuids.size; j++){
			if(level.stats[xuids[i]]["score"]<level.stats[xuids[j]]["score"]){
				temp = xuids[i];
				xuids[i] = xuids[j];
				xuids[j] = temp;
			}
		}
	}
	return xuids;
}

periodicalLog(){
	while(true){
		logStats();
		wait 10;
	}
}
/*updates the Dvars which are used to display the leaderboard in the stats.menu*/
updateDvars(){
	while(true){
		sortedXuids = getSortedXuids();
		rankArray = getRankforXuids(sortedXuids);
		foreach(player in level.players){
			player setClientDvar("ui_showStats", 1);
			i = 1;
			while(i<=10){
				if(player.guid==sortedXuids[i-1]){
					player setClientDvar("stats_name_"+i, "^3"+level.stats[sortedXuids[i-1]]["name"]);
					player setClientDvar("stats_name_"+i, "^3"+level.stats[sortedXuids[i-1]]["name"]);
					player setClientDvar("stats_HKills_"+i, "^3"+level.stats[sortedXuids[i-1]]["HKills"]);
					player setClientDvar("stats_HDeaths_"+i, "^3"+level.stats[sortedXuids[i-1]]["HDeaths"]);
					player setClientDvar("stats_ZKills_"+i, "^3"+level.stats[sortedXuids[i-1]]["ZKills"]);
					player setClientDvar("stats_ZDeaths_"+i, "^3"+level.stats[sortedXuids[i-1]]["ZDeaths"]);
					player setClientDvar("stats_time_"+i, "^3"+formatTime(level.stats[sortedXuids[i-1]]["HTime"]));
					player setClientDvar("stats_score_"+i, "^3"+level.stats[sortedXuids[i-1]]["score"]);
				}else{
					player setClientDvar("stats_name_"+i, level.stats[sortedXuids[i-1]]["name"]);
					player setClientDvar("stats_HKills_"+i, level.stats[sortedXuids[i-1]]["HKills"]);
					player setClientDvar("stats_HDeaths_"+i, level.stats[sortedXuids[i-1]]["HDeaths"]);
					player setClientDvar("stats_ZKills_"+i, level.stats[sortedXuids[i-1]]["ZKills"]);
					player setClientDvar("stats_ZDeaths_"+i, level.stats[sortedXuids[i-1]]["ZDeaths"]);
					player setClientDvar("stats_time_"+i, formatTime(level.stats[sortedXuids[i-1]]["HTime"]));
					player setClientDvar("stats_score_"+i, level.stats[sortedXuids[i-1]]["score"]);
				}
				i++;
			}
			player setClientDvar("stats_name_11", "^3"+level.stats[player.guid]["name"]);
			player setClientDvar("stats_self_rank", "^3"+rankArray[player.guid]+".");
			player setClientDvar("stats_HKills_11", "^3"+level.stats[player.guid]["HKills"]);
			player setClientDvar("stats_HDeaths_11", "^3"+level.stats[player.guid]["HDeaths"]);
			player setClientDvar("stats_ZKills_11", "^3"+level.stats[player.guid]["ZKills"]);
			player setClientDvar("stats_ZDeaths_11", "^3"+level.stats[player.guid]["ZDeaths"]);
			player setClientDvar("stats_time_11", "^3"+formatTime(level.stats[player.guid]["HTime"]));
			player setClientDvar("stats_score_11", "^3"+level.stats[player.guid]["score"]);
			if(rankArray[player.guid]>10) player setClientDvar("ui_showSelfStat", 1);
			else player setClientDvar("ui_showSelfStat", 0);
			player closeMenus();
			player closepopupMenu();
			player closeInGameMenu();
			player openPopupMenu(game["menu_stats"]);
			wait 1;
		}
		wait 10;
	}
}
/*opens the menu which shows the leaderboard for "time" seconds*/
showStats(time){
	for(i=0;i<time;i++){
		foreach(player in level.players){
			player closeMenus();
			player closepopupMenu();
			player closeInGameMenu();
			player openPopupMenu(game["menu_stats"]);
		}
		wait 1;
	}
	foreach(player in level.players){
		player closeMenus();
		player closepopupMenu();
		player closeInGameMenu();
	}
}

/*monitors the time a player has been alive/zombie and periodically updates the score
	which he gets for being alive [score=int(numberOfZombies/numberOfHumans*5)]*/
monitorTime(){
	while(true){
		if(level.gamestate=="playing"){
			numberOfZombies=0;
			numberOfHumans=0;
			foreach(player in level.players){
				if(player.isZombie!=0) numberOfZombies++;
				else numberOfHumans++;
			}
			if(self.isZombie==0){
				level.stats[self.guid]["HTime"]+=10;
				level.stats[self.guid]["score"]+=int(numberOfZombies/numberOfHumans*5);
			}else{
				level.stats[self.guid]["ZTime"]+=10;
			}
		}
		wait 10;
	}
}
/*formats the time into hh:mm:ss format*/
formatTime(time){
		hours = int(time/3600);
		minutes = int(time%3600/60);
		seconds = int(time%60);
		if(hours<10) hours ="0"+hours;
		if(minutes<10) minutes = "0"+minutes;
		if(seconds<10) seconds = "0"+seconds;
		return hours+":"+minutes+":"+seconds;
}
/*returns an array of ranks (starting at 1) indexed by xuids, takes an array of sorted xuids as input */
getRankforXuids(xuids){
	rankArray = [];
	i = 1;
	for(i=0;i<xuids.size;i++){
			rankArray[xuids[i]] = i+1;
	}
	return rankArray;
}
