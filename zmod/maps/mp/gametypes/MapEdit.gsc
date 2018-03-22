#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
init()
{
	level.doCustomMap = 0;
	mapwait = getdvarInt("scr_zmod_mapwait_time");
	level.doorwait = 2;
	level.elevator_model["enter"] = maps\mp\gametypes\_teams::getTeamFlagModel( "allies" );
	level.elevator_model["exit"] = maps\mp\gametypes\_teams::getTeamFlagModel( "axis" );
	level.waittime = 0;
	level.flag_ref = 0;
	level.door_ref = 0;
	precacheModel( level.elevator_model["enter"] );
	precacheModel( level.elevator_model["exit"] );
	level.oi = maps\mp\gametypes\_teams::getTeamFlagIcon( "allies" );
	precacheShader(level.oi);
	//precacheShader(maps\mp\gametypes\_teams::getTeamFlagIcon( "allies" ));
	wait 1;
	
	
	if(getDvar("mapname") == "mp_afghan"){ /** Afghan **/
		level thread Afghan();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_boneyard"){ /** Scrapyard **/
		level thread Scrapyard();
		level.doCustomMap = 1;
        }
	if(getDvar("mapname") == "mp_trailerpark"){ /** trailerpark **/
		level thread trailerpark();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_brecourt"){ /** Wasteland **/
		level thread Wasteland();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_checkpoint"){ /** Karachi **/
		level thread Karachi();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_derail"){ /** Derail **/
		level thread Derail();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_estate"){ /** Estate **/
		level thread Estate();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_favela"){ /** Favela **/
		level thread Favela();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_fuel2"){ /** Fuel **/
		level thread Fuel();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_highrise"){ /** HighRise **/
		level thread HighRise();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_nightshift"){ /** Skidrow **/
		level thread Skidrow();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_storm"){ /** Storm **/
		level thread Skidrow();
		level.doCustomMap = 1;
        }
	if(getDvar("mapname") == "mp_invasion"){ /** Invasion **/
		level thread Invasion();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_quarry"){ /** Quarry **/
		level thread Quarry();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_rundown"){ /** Rundown **/
		level thread Rundown();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_rust"){ /** Rust **/
		level thread Rust();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_subbase"){ /** SubBase **/
		level thread SubBase();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_terminal"){ /** Terminal **/
		level thread Terminal();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_underpass"){ /** Underpass **/
		level thread Underpass();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_abandon"){ /** Carnaval **/
		level thread Carnaval();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_compact"){ /** Salvage **/
		level thread Salvage();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_complex"){ /** Bailout **/
		level thread Bailout();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_crash"){ /** Crash **/
		level thread Crash();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_strike"){ /** Strike **/
		level thread Strike();
		level.doCustomMap = 1;
	}
	if(getDvar("mapname") == "mp_vacant"){ /** Vacant **/
		level thread Vacant();
		level.doCustomMap = 1;
	}
	level.gameState = "starting";
	if(level.doCustomMap == 1){
		level thread CreateMapWait(mapwait);
	} else {
		level thread CreateMapWait(5);
	}
}

CreateMapWait(waittime)
{
	for(i = waittime; i > 0; i--)
	{
		level.TimerText destroy();
		level.TimerText = level createServerFontString( "objective", 1.5 );
		level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
		level.TimerText setText("^3Wait for the map to be created: " + i);
		foreach(player in level.players)
		{
			player freezeControls(true);
			player VisionSetNakedForPlayer("mpIntro", 0);
		}
		wait 1;
	}
	level.TimerText setText("Done!");
	level notify("CREATED");
	foreach(player in level.players)
	{
		player freezeControls(false);
		player VisionSetNakedForPlayer(getDvar("mapname"), 0);
	}
}

CreateElevator(enter, exit, angle)
{
	flag = spawn( "script_model", enter );
	flag setModel( level.elevator_model["enter"] );
	wait level.waittime;
	flag = spawn( "script_model", exit );
	flag setModel( level.elevator_model["exit"] );
	wait level.waittime;
	self thread ElevatorThink(enter, exit, angle);
	o = maps\mp\gametypes\_objpoints::createTeamObjpoint("elevator_flag_" + level.flag_ref, enter + (0, 0, 35), "all", level.oi, 0.8, 1.0);
	o.alpha = 1;
	o.isShown = true;
	Objective_Add(level.flag_ref+1, "active", enter);
	Objective_Icon(level.flag_ref+1, undefined);
	level.flag_ref++;
}

CreateBlocks(pos, angle)
{
	block = spawn("script_model", pos );
	block setModel("com_plasticcase_friendly");
	block.angles = angle;
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	wait level.waittime;
}

CreateRamps(top, bottom)
{
	D = Distance(top, bottom);
	blocks = roundUp(D/30);
	CX = top[0] - bottom[0];
	CY = top[1] - bottom[1];
	CZ = top[2] - bottom[2];
	XA = CX/blocks;
	YA = CY/blocks;
	ZA = CZ/blocks;
	CXY = Distance((top[0], top[1], 0), (bottom[0], bottom[1], 0));
	Temp = VectorToAngles(top - bottom);
	BA = (Temp[2], Temp[1] + 90, Temp[0]);
	for(b = 0; b < blocks; b++){
		block = spawn("script_model", (bottom + ((XA, YA, ZA) * b)));
		block setModel("com_plasticcase_friendly");
		block.angles = BA;
		block Solid();
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		wait level.waittime;
	}
	block = spawn("script_model", (bottom + ((XA, YA, ZA) * blocks) - (0, 0, 5)));
	block setModel("com_plasticcase_friendly");
	block.angles = (BA[0], BA[1], 0);
	block Solid();
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	wait level.waittime;
}

CreateGrids(corner1, corner2, angle)
{
	W = Distance((corner1[0], 0, 0), (corner2[0], 0, 0));
	L = Distance((0, corner1[1], 0), (0, corner2[1], 0));
	H = Distance((0, 0, corner1[2]), (0, 0, corner2[2]));
	CX = corner2[0] - corner1[0];
	CY = corner2[1] - corner1[1];
	CZ = corner2[2] - corner1[2];
	ROWS = roundUp(W/55);
	COLUMNS = roundUp(L/30);
	HEIGHT = roundUp(H/20);
	XA = CX/ROWS;
	YA = CY/COLUMNS;
	ZA = CZ/HEIGHT;
	center = spawn("script_model", corner1);
	for(r = 0; r <= ROWS; r++){
		for(c = 0; c <= COLUMNS; c++){
			for(h = 0; h <= HEIGHT; h++){
				block = spawn("script_model", (corner1 + (XA * r, YA * c, ZA * h)));
				block setModel("com_plasticcase_friendly");
				block.angles = (0, 0, 0);
				block Solid();
				block LinkTo(center);
				block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
				wait level.waittime;
			}
		}
	}
	center.angles = angle;
}

CreateWalls(start, end)
{
	D = Distance((start[0], start[1], 0), (end[0], end[1], 0));
	H = Distance((0, 0, start[2]), (0, 0, end[2]));
	blocks = roundUp(D/55);
	height = roundUp(H/30);
	CX = end[0] - start[0];
	CY = end[1] - start[1];
	CZ = end[2] - start[2];
	XA = (CX/blocks);
	YA = (CY/blocks);
	ZA = (CZ/height);
	TXA = (XA/4);
	TYA = (YA/4);
	Temp = VectorToAngles(end - start);
	Angle = (0, Temp[1], 90);
	for(h = 0; h < height; h++){
		block = spawn("script_model", (start + (TXA, TYA, 10) + ((0, 0, ZA) * h)));
		block setModel("com_plasticcase_friendly");
		block.angles = Angle;
		block Solid();
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		wait level.waittime/10;
		for(i = 1; i < blocks; i++){
			block = spawn("script_model", (start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)));
			block setModel("com_plasticcase_friendly");
			block.angles = Angle;
			block Solid();
			block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
			wait level.waittime/10;
		}
		block = spawn("script_model", ((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h)));
		block setModel("com_plasticcase_friendly");
		block.angles = Angle;
		block Solid();
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		wait level.waittime/10;
	}
}

CreateCluster(amount, pos, radius)
{
	for(i = 0; i < amount; i++)
	{
		half = radius / 2;
		power = ((randomInt(radius) - half), (randomInt(radius) - half), 500);
		block = spawn("script_model", pos + (0, 0, 1000) );
		block setModel("com_plasticcase_friendly");
		block.angles = (90, 0, 0);
		block PhysicsLaunchServer((0, 0, 0), power);
		block Solid();
		block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		block thread ResetCluster(pos, radius);
		wait level.waittime;
	}
}

ElevatorThink(enter, exit, angle)
{
	self endon("disconnect");
	while(1)
	{
		foreach(player in level.players)
		{
			if(Distance(enter, player.origin) <= 50){
				player SetOrigin(exit);
				player SetPlayerAngles(angle);
			}
		}
		wait .25;
	}
}

CreateDoors(open, close, angle, size, height, hp, range)
{
	offset = (((size / 2) - 0.5) * -1);
	center = spawn("script_model", open );
	for(j = 0; j < size; j++){
		door = spawn("script_model", open + ((0, 30, 0) * offset));
		door setModel("com_plasticcase_enemy");
		door Solid();
		door CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
		door EnableLinkTo();
		door LinkTo(center);
		for(h = 1; h < height; h++){
			door = spawn("script_model", open + ((0, 30, 0) * offset) - ((70, 0, 0) * h));
			door setModel("com_plasticcase_enemy");
			door Solid();
			door CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
			door EnableLinkTo();
			door LinkTo(center);
		}
		offset += 1;
	}
	center.angles = angle;
	center.state = "open";
	center.hp = hp;
	center.msg = 0;
	center.maxhp = hp;
	center.range = range;
	center.moving = false;
	level.door_ref++;
	center.id = level.door_ref;
	center thread DoorThink(open, close);
	center thread DoorUse();
	center thread ResetDoors(open, hp);
	wait level.waittime;
}
//Door repairing
	
DoorRepairLoop(open, close)
{
	while (1)
	{
		
		self waittill ( "triggeruse" , player );
		if (player.team == "allies" && player.isRepairing)
			if (player maps\mp\gametypes\_shop_menu::getHItemVal("repair", "in_use") > 0)
			{
				iPrintlnBold("doorrepairloop");
				if (self.hp >= self.maxhp)
				{
					player iPrintlnBold("^3DOOR IS AT MAX!");
					continue;
				}
				player maps\mp\gametypes\_shop_menu::setHItemVal("repair", "in_use", player maps\mp\gametypes\_shop_menu::getHItemVal("repair", "in_use")-1);
				self.hp++;
				player iPrintlnBold("DOOR REPAIRED! HP: " + self.hp + "/" + self.maxhp + " LEFT: " + player maps\mp\gametypes\_shop_menu::getHItemVal("repair", "in_use"));
				//If door is broken, immediately close it
				if (self.state == "broken")
				{
					self MoveTo(close, 0.001);
					wait 0.001;
					self.state = "close";
					player SayAll("^5Door ^2FIXED!");
				}
				//Remove their tool if they're out
				continue;
			}
		wait 0.2;
	}
}

canUseDoor()
{
	return !self.isRepairing && self getCurrentWeapon() != "defaultweapon_mp" && !self isInKillcam();
}
		
DoorThink(open, close)
{
	self thread DoorRepairLoop(open, close);
	while(1)
	{
		if(self.hp > 0){
			self waittill ( "triggeruse" , player );
			if(player.team == "allies"){
				if (player canUseDoor())
					if(self.state == "open"){
						self MoveTo(close, level.doorwait);
						player thread maps\mp\gametypes\_quickmessages::quickstatements("4");
						player SayAll("^5Door ^2Closed");
						self.moving = true;
						wait level.doorwait;
						self.moving = false;
						self.state = "close";
						continue;
					}
					else
						if(self.state == "close"){
							self MoveTo(open, level.doorwait);
							player thread maps\mp\gametypes\_quickmessages::quickcommands("2");
							player SayAll("^5Door ^3Opened");
							self.moving = true;
							wait level.doorwait;
							self.moving = false;
							self.state = "open";
							continue;
						}
			}
			if(player.team == "axis"){
				if(self.state == "close" && isAlive(player)){
					self.hp -= player.atk;
					if (self.hp < 0)
						self.hp = 0;
					player iPrintlnBold("HIT! HP: " + self.hp + "/" + self.maxhp);
					if (self.hp < 5 && self.msg == 0)
					{
						player SayAll("Door ^3Almost Broken!");
						self.msg = 1;
					}
					
					if (self.hp == 0)
						player SayAll("Door ^1Destroyed!");
					wait 0.6;
					continue;
				}
			}
		} else {
			if(self.state == "close"){
				self MoveTo(open, level.doorwait);
			}
			self.state = "broken";
			wait .5;
		}
	}
}


DoorUse(range)
{
	self endon("disconnect");
	while(1)
	{
		foreach(player in level.players)
		{
			if(Distance(self.origin, player.origin) <= self.range){
				txt = "";
				if (!player.doorInRange)
					player.doorInRange = self.id;
				else
					if (player.doorInRange != self.id)
						continue;
				if (!self.moving)
				{
					if(player.team == "allies")
					{
						if (!player.isRepairing)
						{
							if (self.state == "broken")
								txt = "^1Door is Broken";
							else
								if (player canUseDoor())
								{
									if (self.state == "open")
										txt = "Press ^3[{+activate}] ^7to ^2Close ^7the door";
									else
										if (self.state == "close")
											txt = "Press ^3[{+activate}] ^7to ^2Open ^7the door";
								}
								else
											txt = "";
						}
						else
						{
							if (self.hp >= self.maxhp)
								txt = "DOOR ^3IS AT MAX HP!";
							else
								txt = "Press ^3[{+activate}] ^7to ^2REPAIR ^7the door";
						}
					}
					else
						if(player.team == "axis")
						{
							if(self.state == "close")
								txt = "Press ^3[{+activate}] ^7to ^2Attack ^7the door";
							else
							if(self.state == "broken")
								txt = "^1Door is Broken";
							else
								txt = "^1Door is Open";
						}
				}
				else
					txt = "Please wait for door";
				
				if (!isDefined(player.doorprogbar)){
					player.doorprogbar = player createPrimaryProgressBar();
					player.doorprogtext = player createPrimaryProgressBarText();
					maps\mp\gametypes\_rank::clog ("created thing for: " + player.name);
				}
				player.doorprogbar updateBarScale(self.hp / self.maxhp);
				if (player.doorprogbar.hidden)
					player.doorprogbar showElem();
				if (txt != "") {
					player.doorprogtext setText(txt);
					if (player.doorprogtext.hidden)
						player.doorprogtext showElem();
				}
				else
					if (!player.doorprogtext.hidden)
						player.doorprogtext hideElem();	
				if(player.buttonPressed[ "+activate" ] == 1){
					player.buttonPressed[ "+activate" ] = 0;
					self notify( "triggeruse" , player);
				}
			}
			else
			{
				if (isDefined(player.doorprogbar) && player.doorInRange == self.id)
				{
					if (!player.doorprogbar.hidden)
						player.doorprogbar hideElem();
					if (!player.doorprogtext.hidden)
						player.doorprogtext hideElem();
					player.doorInRange = 0;
				}
			}
		}
		wait .045;
	}
}

ResetDoors(open, hp)
{
	while(1)
	{
		level waittill("RESETDOORS");
		self.hp = hp;
		self MoveTo(open, level.doorwait);
		self.state = "open";
		self.msg = 0;
	}
}

ResetCluster(pos, radius)
{
	wait 5;
	self RotateTo(((randomInt(36)*10), (randomInt(36)*10), (randomInt(36)*10)), 1);
	level waittill("RESETCLUSTER");
	self thread CreateCluster(1, pos, radius);
	self delete();
}

roundUp( floatVal )
{
	if ( int( floatVal ) != floatVal )
		return int( floatVal+1 );
	else
		return int( floatVal );
}
CreateForce(start, end) {
    D = Distance((start[0], start[1], 0), (end[0], end[1], 0));
    H = Distance((0, 0, start[2]), (0, 0, end[2]));
    blocks = roundUp(D / 55);
    height = roundUp(H / 30);
    CX = end[0] - start[0];
    CY = end[1] - start[1];
    CZ = end[2] - start[2];
    XA = (CX / blocks);
    YA = (CY / blocks);
    ZA = (CZ / height);
    TXA = (XA / 4);
    TYA = (YA / 4);
    Temp = VectorToAngles(end - start);
    Angle = (0, Temp[1], 90);
    for (h = 0; h < height; h++) {
        block = spawn("script_model", (start + (TXA, TYA, 10) + ((0, 0, ZA) * h)));
        block setModel(level.chopper_fx["light"]["belly"]);
        block.angles = Angle;
        block Solid();
        block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
        wait 0.001;
        for (i = 1; i < blocks; i++) {
            block = spawn("script_model", (start + ((XA, YA, 0) * i) + (0, 0, 10) + ((0, 0, ZA) * h)));
            block setModel(level.chopper_fx["light"]["belly"]);
            block.angles = Angle;
            block Solid();
            block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
            wait 0.001;
        }
        block = spawn("script_model", ((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, ZA) * h)));
        block setModel(level.chopper_fx["light"]["belly"]);
        block.angles = Angle;
        block Solid();
        block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
        wait 0.001;
    }
}
CreateAsc(depart, arivee, angle, time) {
    Asc = spawn("script_model", depart);
    Asc setModel("com_plasticcase_friendly");
    Asc.angles = angle;
    Asc Solid();
    Asc CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
    Asc thread Escalator(depart, arivee, time);
}
Escalator(depart, arivee, time) {
    while (1) {
        if (self.state == "open") {
            self MoveTo(depart, time);
            wait(time * 1.5);
            self.state = "close";
            continue;
        }
        if (self.state == "close") {
            self MoveTo(arivee, time);
            wait(time * 1.5);
            self.state = "open";
            continue;
        }
    }
}

Afghan()
{
CreateRamps((1254, 1344, 620), (2568, 1253, 35));
CreateGrids((1225, 1325, 620), (1101, 1526, 620));
CreateGrids((1225, 1325, 740), (1101, 1526, 740));
CreateDoors((1240, 1409, 665), (1240, 1338, 665), (0, 90, 90), 3, 1, 20, 50);

CreateWalls((1239, 1515, 635), (1241, 1392, 722));
CreateWalls((1087, 1322, 635), (1190, 1321, 722));

CreateElevator((1072, 1537, 635), (-1735, 464, 450), (0, 180, 0));
CreateElevator((-1827, -83, 437), (1078, 1537, 756), (0, 0, 0));

mgTurret1 = spawnTurret( "misc_turret", (1245, 1338, 785), "pavelow_minigun_mp" );
mgTurret1 setModel( "weapon_minigun" );
mgTurret1.angles = (0, 0, 0);
CreateBlocks((1240, 1338, 750), (45, 0, 0));



//CreateWalls((2297, -151, 144), (2297, -48, 158));
//CreateWalls((2297, -151, 195), (2297, -48, 187));
//CreateDoors((1583, -160, 175), (1583, -210, 172), (0, 90, 90), 2, 2, 400, 50);
//CreateElevator((-1697, -98, 404), (2261, 64, 137), (0, 0, 0));
//CreateElevator((2007, -292, 137), (-1735, 464, 450), (0, 0, 0));
//CreateBlocks((1081, 1556, 620), (0, 45, 0));
//mgTurret1 = spawnTurret( "misc_turret", (1835, 127, 168), "pavelow_minigun_mp" );
//mgTurret1 setModel( "weapon_minigun" );
//mgTurret1.angles = (0, 90, 0);

//CreateGrids((885, 1004, 373), (956, 765, 372));
//CreateWeapon("cheytac_fmj_xmags_mp", 100, (890, 895, 380), (0, 90, 0)); //Weaps
//mgTurret1 = spawnTurret( "misc_turret", (979, 1012, 433), "pavelow_minigun_mp" ); 
//mgTurret1 setModel( "weapon_minigun" );
//mgTurret1.angles = (0, 0, 0);
//CreateElevator((1002, 1870, 411), (1754, 827, 233));
//CreateGrids((1550, 647, 190), (1740, 395, 190));
//CreateElevator((1627, 399, 192), (909, 1000, 388));
//CreateRamps((2332, 1518, 11), (2293, 1319, 122));
//CreateWalls((985, 1042, 381), (993, 771, 386));
}
trailerpark()
{
	CreateElevator((-2272, 1173, -102), (-2250, 1941, -102));
	CreateElevator((-3075, 3250, 230), (-2271, 1600, -92), (0, 0, 0));
	CreateElevator((-2326, 1428, -100), (-3225, 3250, 250), (0, 0, 0));

        CreateRamps((-2240, 1856, 24), (-2397, 1856, 125));
	CreateGrids((-3000, 2857, 100), (-3350, 3300, 100), (0, 0, 0));// middle = debth
	CreateGrids((-3110, 3000, 220), (-3350, 3300, 220), (0, 0, 0));
	CreateGrids((-3000, 3000, 340), (-3240, 3300, 340), (0, 0, 0));//top one
        CreateRamps((-3300, 3030, 340), (-3300, 3200, 220));
	CreateDoors((-3300, 3300, 340), (-3300, 3150, 340), (0, 0, 0), 6, 1, 15, 60);
        CreateRamps((-3000, 2850, 220), (-3300, 2850, 220));
	CreateElevator((-3300, 2900, 220), (-3075, 3100, 380), (0, 270, 0));


	CreateWalls((-3000, 3000, 100), (-3080, 3000, 340));
	CreateWalls((-3270, 3000, 100), (-3350, 3000, 340));
	CreateDoors((-3300, 3000, 125), (-3175, 3000, 125), (90, 90, 0), 6, 2, 15, 60);
	CreateWalls((-3000, 3300, 100), (-3000, 3000, 340));
	CreateWalls((-3000, 3300, 100), (-3350, 3300, 340));
	CreateWalls((-3350, 3300, 100), (-3350, 3000, 340));
	CreateRamps((-3050, 3050, 220), (-3050, 3220, 100));
	CreateWalls((-3000, 3000, 250), (-3350, 3000, 280));

	CreateWalls((-2354, 1869, -93), (-2445, 1869, -10));
	CreateForce((-2219, 2300, -102), (-2954, 2300, 80));
	CreateElevator((-2950, 1913, 0), (-3107, 2384, 115), (0, 0, 0));
	CreateForce((-2982, 2325, 103), (-2951, 2315, 160));

	CreateForce((-3058, 2331, 122), (-3058, 2820, 150));
	CreateForce((-3168, 2331, 122), (-3168, 2820, 150));
}


Derail()
{	//Crashes game, too many entities
	/*
	//Funky Edit Start
	
	//All Forces
	CreateForce((-1362, -3247, 160), (-1350, -2626 , 156));
	CreateForce((659, -2706 ,121), (819, -3103 , 240));
	CreateForce((1046 , -3445, 137), (919, -3435 , 242));
	CreateForce((656, -2677 , 224), (665, -2074, 359));
	CreateForce((637, -2017 ,361), (631, -1768, 218));
	CreateForce((-1018, -1769 ,257), (620, -1771, 344));
	CreateForce((-2549, -70 ,37), (-4556, -116, 214));
	CreateForce((-4502, -122 ,157), (-4165, -2658, 549));
	CreateForce((-2041, -2653 ,235), (-4457, -2205, 728));
	
	//All Walls
	//CreateWalls((-1353, -3247, 160), (-1349, -2626, 156));
	//CreateWalls((814, -3104, 173), (658, -2706, 165));
	//CreateWalls((1045, -3444, 188), (920, -3439, 191));
	CreateWalls((533, -1758, 124), (462, -1757, 204));
	CreateWalls((-1143, -2035, 134), (-1046, -2034, 154));
	CreateWalls((-1143, -2042, 190), (-1046, -2037, 202));
	CreateWalls((-1024, -1910, 132), (-1019, -2007, 220));
	CreateWalls((-319, -1918, 147), (-293, -1788, 161));
	CreateWalls((-314, -1918, 202), (-294, -1791, 223));
	CreateWalls((-22, -1788, 182), (-25, -1880, 184));
	CreateWalls((-299, -2303, 283), (-298, -2325, 279));
	CreateWalls((922, -3118, 255), (922, -3130, 255));
	CreateWalls((778, -3143, 256), (777, -3113, 256));
	CreateWalls((779, -3528, 276), (772, -3568, 261));
	CreateWalls((-658, -3522, 98), (-664, -3561, 164));
	CreateWalls((-419, -3444, 98), (-385, -3446, 175));
	CreateWalls((-391, -3575, 98), (-387, -3681, 114));
	CreateWalls((-206, -3618, 129), (-204, -3694, 168));
	CreateWalls((-15, -3568, 98), (138, -3563, 100));
	
	//All Ramps
	CreateRamps((-288, -2092, 295), (-92, -2101, 342));
	CreateRamps((-2895, -1570, 345), (-3299, -1382, 592));
	CreateRamps((-3352, -1410, 626), (-3354, -1599, 736));
	
	//Teleporter
	CreateElevator((-168, -3391, 90), (-814, -1212, 567));
	CreateElevator((-805, -2327, 130), (-2463, -2252, 268));
	CreateElevator((-3718, -1810, 887), (-1065, -3657, 103));
	CreateElevator((-674, -1014, 567), (-786, -1124, 302));

	*/

//CreateElevator((, , ), (, , -));
//CreateWalls((, , ), (, , ));
//CreateForce((,  ,), (, , ));
//CreateRamps((, , ), (, , ));



	//CreateDoors((1673, 4488, 217), (1680, 4825, 216), (90, 180, 0), 10, 2, 20, 75)
	//Funky Edit End
}


Estate()
{
	/*CreateBlocks((-2378, 782, -130), (90, 0, 0));
	CreateBlocks((-2388, 823, -130), (90, 0, 0));
	CreateBlocks((-2398, 863, -130), (90, 0, 0));*/
	CreateBlocks((-1098, 2623, 37), (90, 0, 0));
	//CreateBlocks((-3227, 3483, -101), (90, 0, 0));
	CreateBlocks((-371, 919, 245), (0, 100, 90));
	CreateBlocks((-383, 991, 245), (0, 100, 90));
	CreateBlocks((-371, 919, 275), (0, 100, 90));
	CreateBlocks((-383, 991, 275), (0, 100, 90));
	CreateBlocks((-371, 919, 305), (0, 100, 90));
	CreateBlocks((-383, 991, 305), (0, 100, 90));
	CreateBlocks((-371, 919, 335), (0, 100, 90));
	CreateBlocks((-383, 991, 335), (0, 100, 90));
	CreateBlocks((-349, 1115, 245), (0, 50, 90));
	CreateBlocks((-302, 1166, 245), (0, 50, 90));
	CreateBlocks((-349, 1115, 275), (0, 50, 90));
	CreateBlocks((-302, 1166, 275), (0, 50, 90));
	CreateBlocks((-349, 1115, 305), (0, 50, 90));
	CreateBlocks((-302, 1166, 305), (0, 50, 90));
	CreateBlocks((-349, 1115, 335), (0, 50, 90));
	CreateBlocks((-302, 1166, 335), (0, 50, 90));
	CreateBlocks((-371, 919, 395), (0, 100, 90));
	CreateBlocks((-383, 991, 395), (0, 100, 90));
	CreateBlocks((-371, 919, 425), (0, 100, 90));
	CreateBlocks((-383, 991, 425), (0, 100, 90));
	CreateBlocks((-371, 919, 455), (0, 100, 90));
	CreateBlocks((-383, 991, 455), (0, 100, 90));
	CreateBlocks((-371, 919, 485), (0, 100, 90));
	CreateBlocks((-383, 991, 485), (0, 100, 90));
	CreateBlocks((-349, 1115, 395), (0, 50, 90));
	CreateBlocks((-302, 1166, 395), (0, 50, 90));
	CreateBlocks((-349, 1115, 425), (0, 50, 90));
	CreateBlocks((-302, 1166, 425), (0, 50, 90));
	CreateBlocks((-349, 1115, 455), (0, 50, 90));
	CreateBlocks((-302, 1166, 455), (0, 50, 90));
	CreateBlocks((-349, 1115, 485), (0, 50, 90));
	CreateBlocks((-302, 1166, 485), (0, 50, 90));
	CreateBlocks((-55, 1231, 245), (0, -20, 90));
	CreateBlocks((8, 1217, 245), (0, -20, 90));
	CreateBlocks((102, 1188, 245), (0, -20, 90));
	CreateBlocks((162, 1168, 245), (0, -20, 90));
	CreateBlocks((-55, 1231, 275), (0, -20, 90));
	CreateBlocks((8, 1217, 275), (0, -20, 90));
	CreateBlocks((102, 1188, 275), (0, -20, 90));
	CreateBlocks((162, 1168, 275), (0, -20, 90));
	/*
	CreateBlocks((-3200, 998, -143), (90, 0, 0));
	CreateBlocks((-3200, 1028, -143), (90, 0, 0));
	CreateBlocks((-3200, 1058, -143), (90, 0, 0));
	CreateBlocks((-3200, 1088, -143), (90, 0, 0));
	CreateBlocks((-3200, 1118, -143), (90, 0, 0));
	CreateBlocks((-3181, 3124, -218), (90, 0, 0));
	CreateBlocks((-3211, 3124, -218), (90, 0, 0));
	CreateBlocks((-3241, 3124, -218), (90, 0, 0));
	CreateBlocks((-3181, 3124, -163), (90, 0, 0));
	CreateBlocks((-3211, 3124, -163), (90, 0, 0));
	CreateBlocks((-3241, 3124, -163), (90, 0, 0));
	CreateBlocks((-2622, 3676, -106), (90, 0, 0));
	CreateBlocks((-3741, 3245, -200), (90, 0, 0));
	CreateBlocks((-3821, 2170, -250), (90, 0, 0));
	CreateBlocks((-3791, 2170, -250), (90, 0, 0));
	CreateBlocks((-3761, 2170, -250), (90, 0, 0));
	CreateBlocks((-3821, 2170, -195), (90, 0, 0));
	CreateBlocks((-3791, 2170, -195), (90, 0, 0));
	CreateBlocks((-3761, 2170, -195), (90, 0, 0));*/
	
	/*CreateBlocks((-471, -126, 193), (0, 0, 90));
	CreateBlocks((-547, -104, 193), (0, 0, 90));
	CreateBlocks((-625, -84, 193), (0, 0, 90));
	CreateBlocks((-702, -61, 193), (0, 0, 90));
	CreateBlocks((-778, -38, 193), (0, 0, 90));
	CreateBlocks((-830, -13, 193), (0, 0, 90));*/
	
	CreateElevator((-95, -549, 340),(-2102.5, 2626, 16.5) , (0, 180, 0));
	CreateElevator((-2328.4, 2231, 35), (468, 811, 666), (0, 0, 0));
	CreateElevator((-1695.1, 2720.9, .8), (-896, -307, 355), (0, 0, 0));
	CreateElevator((-440, 1075.3, 686), (1279, 3926, 374), (0, 0, 0));
	
	CreateGrids((-342, 928, 450), (-173, 1194, 450));
	
	CreateRamps((82, 880, 334), (-156.8, 923, 443.5));
	
	CreateRamps((-432, 76.7, 72), (-517, -323.2, 303));
	
	CreateDoors((621, 839, 48), (743, 763.6, 49), (90, 70, 0), 4, 2, 20, 75);
	
	
	CreateBlocks((1333, -92, 210), (0, 0, 90));
	CreateDoors((489, 1321, 212), (409, 1341, 212), (90, 70, 0), 4, 2, 20, 75);
	CreateDoors((421, 861, 212), (461, 1011, 212), (90, -20, 0), 4, 2, 20, 75);
	CreateDoors((64, 680, 212), (184, 640, 212), (90, 75, 0), 6, 2, 30, 100);
	CreateDoors((706, 575, 185), (791, 545, 185), (0, -15, 0), 6, 1, 25, 75);
	CreateDoors((24, 477, 341), (48, 552, 341), (90, -15, 0), 3, 2, 5, 50);
}

Favela()
{
	CreateElevator((-1975, 795, 8), (14950, -11250, -831), (0, 180,0));
	CreateElevator((14975, -11050, -831), (-1460, 1515, 162), (0, 0, 0));
	CreateWalls((14000, -11000, -832), (15000, -11000, -772));
	CreateWalls((15000, -11000, -832), (15000, -11500, -772));
	CreateWalls((15000, -11500, -832), (14000, -11500, -772));
	CreateWalls((14000, -11500, -832), (14000, -11000, -652));
	CreateWalls((14300, -11500, -772), (14000, -11500, -652));
	CreateWalls((14000, -11000, -772), (14300, -11000, -652));
	CreateWalls((14300, -11000, -832), (14300, -11175, -772));
	CreateWalls((14300, -11325, -832), (14300, -11500, -772));
	CreateWalls((14300, -11000, -742), (14300, -11500, -702));
	CreateWalls((14300, -11000, -653), (14300, -11500, -652));
	CreateRamps((14040, -11470, -727), (14040, -11060, -842));
	CreateGrids((14095, -11030, -732), (14260, -11470, -732), (0,0,0));
	CreateDoors((14300, -11100, -810), (14300, -11250, -810), (90, 180, 0), 5, 2, 25, 75);
	
	// Added
	CreateDoors((-64, 277, 198), (-64, 337, 198), (90, -6, 0), 2, 2, 5, 50);
	CreateDoors((-438, 987, 310), (-438, 1047, 310), (90, 4, 0), 2, 2, 5, 50);
	CreateDoors((-625, -238, 174), (-625, -298, 174), (90, -9, 0), 2, 2, 5, 50);
	CreateDoors((893, 1056, 368), (833, 1056, 368), (90, 90, 0), 2, 2, 5, 50);
	CreateDoors((80, 450, 198), (145, 450, 198), (90, 90, 0), 2, 2, 5, 50);
	CreateElevator((-321, 2633, 335), (1985, 816 , 500), (0, 0, 0));	
	CreateElevator((1993, 962, 500), (1824, -525, 728), (0, 0, 0));
	CreateElevator((1648, -1024, 728), (5047, -2867, 216), (0, 0, 0));
	CreateElevator((763, -1983, 152), (404, 1677, 595), (0, 0, 0));
	
	/*CreateGrids((2809, -2212, 239), (2809, -2675, 230), (0, 0, 0));
	CreateWalls((2809, -2212, 143), (2236, -2212, 240));
	CreateWalls((2809, -2212, 143), (2809, -2400, 180));
	CreateWalls((2809, -2212, 220), (2809, -2675, 240));
	Createwalls((2236, -2212, 143), (2236, -2675, 180));
	CreateWalls((2236, -2675, 143), (2236, -2212, 240));
	CreateWalls((2809, -2675, 143), (2809, -2550, 180));
	CreateWalls((2809, -2675, 143), (2236, -2675, 240));
	CreateRamps((2650, -2600, 143), (2236, -2600, 220));
	CreateDoors((2780, -2300, 143), (2809, -2485, 143), (90, 0, 0), 7, 2, 15, 50);*/
	
	/*CreateElevator((-2148, 4890, 296), (-1481, 1593, 160), (0, 180, 0));
	CreateElevator((-1240, 2457, 293), (-974, 3128, 280), (0, 180, 0));
	CreateElevator((1120, 1706, 292), (1036, 2248, 287), (0, 180, 0));	
	CreateRamps((-2110, 4368, 386), (-1997, 4441, 386));
	CreateRamps((-2145, 4432, 416), (-1867, 3978, 416));
	CreateRamps((-2162, 4762, 296), (-2145, 4432, 416));
	CreateRamps((-1505, 3971, 276), (-1830, 4106, 296));
	CreateWalls((-1854, 4179, 392), (-1478, 4017, 512));
	CreateWalls((-1878, 4207, 424), (-2120, 4931, 476));
	CreateWalls((-2212, 4412, 296), (-2217, 5155, 476));
	CreateWalls((-2212, 4412, 296), (-1906, 3956, 476));
	CreateWalls((-1688, 3930, 296), (-1421, 3628, 392));
	CreateWalls((2739, 3152, 280), (2739, 2842, 432));*/
	
	// Ubber Epic, lets you go on the statues head!
	CreateElevator((-47.092, 3005.96, 572.125), (9799.85, 18484.1, 12643.1), (0, 180, 0));
	CreateElevator((10076.1, 18459.2, 12643.1), (10522, 18402.9, 13635.1), (0, 180, 0));
	CreateElevator((10030.5, 18409, 13635.1), (9935.07, 18432, 13851.1), (0, 180, 0));
	CreateElevator((9362.9, 18432.5, 13635.1), (449.672, 2725.73, 286.431), (0, 180, 0));
}

Fuel()
{
        CreateWalls((-278.001, -6942.001, -180.001), (-50.001, -6980.001, -150.001));
	CreateWalls((-278.001, -6942.001, -240.001), (-50.001, -6980.001, -210.001));
	CreateElevator((-106.001, -41.001, 0.001), (6.001, -4828.001, -255.001));
	CreateWalls((-244.001, -7250.001, -310.001), (-278.001, -6942.001, -150.001));
	CreateWalls((488.001, -7250.001, -250.001), (-244.001, -7250.001, -150.001));
	CreateWalls((488.001, -7002.001, -240.001), (488.001, -7250.001, -180.001));
	CreateWalls((197.001, -6980.001, -180.001), (488.001, -7002.001, -150.001));
	CreateWalls((197.001, -6980.001, -240.001), (488.001, -7002.001, -210.001));
	CreateDoors((-200.001, -6942.001, -240.001), (75.001, -6980.001, -266.001), (90, 90, 0), 7, 2, 35, 75);
	CreateGrids((-244, -7250, -150), (488, -7002, -150), (0, 0, 0));

        CreateDoors((1872.001, -79.001, -197.001), (1865.001, -187.001, -196.001), (90, 0, 0), 5, 2, 35, 75);
	CreateElevator((1331.001, 476.001, -156.001), (23, -5043.001, -248));
	CreateElevator((100.001, -7125.001, -240.001), (100.001, -7125.001, 0.001));
 	CreateElevator((1463, 488, -37), (935, -497, -150), (0, -90, 0));
 	CreateElevator((935, -679, -200), (1599, 264, -157), (0, -90, 0));
	CreateWalls((1423.001, 508.001, -37.001), (1416.001, 275.001, 54.001));
        CreateDoors((1744.001, 119.001, -156.001), (1600.001, 119.001, -157.001), (90, 90, 0), 7, 2, 35, 75);
	CreateElevator((10, -3028, -247), (-50, -2800, -247));
}

HighRise()
{
	CreateRamps((-1574.3, 6293.25, 2955.05),(-1579.79, 6867.9, 3191.71));
	CreateRamps((-1561.91, 6895.73, 3201.11),(-1897.13, 6899.42, 3198.75));
	CreateGrids((-1917.38, 7123.19, 3205.4),(-2390.9, 6766.93, 3205.4));
	CreateDoors((-1898.76, 7023.51, 3220.52),(-1901.83, 6918.8, 3238.12),(90, 0, 0),4,2,15,85);
	CreateWalls((-1896.34, 6939.79, 3248.65),(-1895.04, 7130.99, 3264.91));
	CreateWalls((-1899.18, 6861.37, 3242.15),(-1902.19, 6759.78, 3253.17));
	CreateRamps((-2416.71, 6808.35, 3202.17),(-2615.86, 6809.19, 3213.21));
	CreateDoors((-2632.66, 6907.71, 3232.13),(-2636.55, 6831.46, 3278.66),(90, 0, 0),4,2,20,85);
	CreateWalls((-2633.15, 6749.13, 3232.13),(-2628.77, 6658.38, 3279.56));
	CreateWalls((-2631.31, 6626.45, 3232.13),(-2634.05, 6477.47, 3250.39));
	CreateRamps((-2615.87, 5903.46, 3209.49),(-2319.89, 5883.45, 3192.58));
	CreateGrids((-2306, 5742.5, 3194.08),(-2029.22, 5962.7, 3194.08));
	CreateDoors((-2322.29, 5773.46, 3209.21),(-2319.59, 5855.13, 3241.94),(90, 0, 0),4,2,10,85);
	CreateWalls((-2332.01, 5931.06, 3209.21),(-2324.33, 5983.68, 3252.61));
	CreateWalls((-2329.01, 5841.06, 3209.21),(-2327.57, 5738.12, 3242.96));
}

Invasion()
{
	CreateRamps((-2141, -1883, 845), (-2244, -1390, 572));
	CreateAsc((-2223, -2335, 860), (-2237, -2084, 1020),90,3);
	CreateWalls((-2426, -1532, 862), (-2558, -1564, 869));
	CreateRamps((-2490, -1288, 819), (-2130, -1243, 818));
	CreateWalls((-2034, -1637, 818), (-2011, -1748, 908));
	CreateRamps((-2037, -1623, 892), (-2064, -1492, 818));
	CreateRamps((-1579, -1679, 1081),(-2005, -1755, 902));
	CreateRamps((-2067, -2019, 1021),(-2499, -2111, 1020));
	CreateRamps((-1492, -1472, 1046),(-1657, -1511, 910));
	CreateGrids((-1644, -1526, 1037),(-1630, -1475, 1043),(0, 0, 0));
	CreateWalls((-1515, -1443, 1029),(-1605, -1460, 1029));
	CreateWalls((-1726, -1175, 1115),(-1563, -1141, 1134));
	CreateGrids((-1550, -1699, 1062),(-1561, -1649, 1062),(0, 0, 0));
	CreateElevator(( -297, -1797, 264), (-2282, -1318, 572),(0, 0, 0));
	CreateElevator((-1936, -2579, -295), (-2362, -1356, 572),(0, 0, 0));
	//CreateElevator((-1932, -2582, -297),(-2348, -1332, -572),(0, 90, 0));
	CreateRamps((-2408, -1312, 558), (-2192, -1276, 557));
	CreateRamps((-2490, -1304, 610), (-2383, -1771, 609));
	CreateRamps((-2122, -1257, 610), (-2014, -1726, 609));
	CreateWalls((-1964, -1630, 655), (-2069, -1652, 655));
	//CreateElevator((-971, -1899, -1054), (-1365, -2323, 314),(0, 90, 0));
	CreateForce((-2112, -1650, 855), (-2052, -1845, 1131));
}

Karachi()
{
	CreateElevator((25, 519, 200), (25, 457, 336), (0, 180, 0));
	CreateElevator((-525, 520, 336), (-522, 783, 336), (0, 0, 0));
	CreateElevator((25, 854, 336), (25, 854, 472), (0, 180, 0));
	CreateElevator((-522, 783, 472), (-525, 520, 472), (0, 0, 0));
	CreateElevator((25, 457, 472), (25, 457, 608), (0, 180, 0));
	CreateElevator((-525, 520, 608), (-522, 783, 608), (0, 0, 0));
	CreateElevator((561, 116, 176), (568, -67, 280), (0, 0, 0));
	CreateBlocks((800, 206, 254), (0, 0, 0));
	CreateBlocks((800, 256, 254), (0, 0, 0));
	CreateBlocks((800, 375, 254), (0, 0, 0));
	CreateBlocks((479, -831, 369), (90, 90, 0));
	/*CreateBlocks((768, -253, 582), (90, -45, 0));
	CreateBlocks((814, -253, 582), (90, -45, 0));
	CreateBlocks((860, -253, 582), (90, -45, 0));
	CreateBlocks((916, -253, 582), (90, -45, 0));
	CreateBlocks((962, -253, 582), (90, -45, 0));*/
	CreateBlocks((415, -777, 582), (0, 0, 0));
	CreateBlocks((360, -777, 582), (0, 0, 0));
	CreateBlocks((305, -777, 582), (0, 0, 0));
	CreateBlocks((516, -74, 564), (90, 90, 0));
	CreateBlocks((516, -74, 619), (90, 90, 0));
	CreateRamps((559, -255, 554), (559, -99, 415));
}

Quarry()
{
	CreateBlocks((-5817, -319, -88), (0, 0, 0));
	CreateBlocks((-5817, -289, -108), (0, 0, 0));
	CreateRamps((-3742, -1849, 304), (-3605, -1849, 224));
	CreateRamps((-3428, -1650, 224), (-3188, -1650, 160));
	CreateRamps((-3412, -1800, 416), (-3735, -1800, 304));
	CreateGrids((-3520, -1880, 320), (-3215, -2100, 320), (0, 0, 0));
	CreateGrids((-3100, -1725, 400), (-2740, -1840, 400), (3, 0, 0));
	/*CreateWalls((-4440.14, -476.49, -133.994),(-4679.85, -476.333, -72.4764));
	CreateWalls((-4463.87, 155.113, -43.9992),(-4416.13, 156.306, -28.4648));
	CreateWalls((-4416.13, 156.267, 24.3774),(-4463.87, 155.114, 35.8723));
	CreateWalls((-4251.97, -310.715, 120.125),(-4179.92, -310.802, 128.127));
	CreateWalls((-5048.88, -312.204, 120.125),(-4833.59, -309.912, 128.126));
	CreateWalls((-4803.93, -309.542, 120.125),(-4064.14, -310.282, 131.123));
	CreateWalls((-4239.13, -974.833, 8.45296),(-4343.87, -978.626, 75.6628));
	CreateWalls((-4232.13, -978.466, 103.875),(-4343.85, -983.434, 100.199));
	CreateWalls((-4050.89, -128.157, 392.122),(-4049.87, -191.86, 445.635));
	CreateWalls((-5067.92, -184.358, 352.125),(-5068.75, -128.152, 401.984));
	CreateWalls((-5068.38, -191.872, 429.727),(-5068.44, -128.134, 463.875));*/
}
Rundown()
{
	/* default */
	CreateDoors((360, -1462, 202), (300, -1342, 202), (90, 25, 0), 3, 2, 10, 75);
	CreateDoors((460, -1420, 206), (400, -1300, 206), (90, 25, 0), 3, 2, 10, 75);
	CreateDoors((30, -1630, 186), (-30, -1510, 186), (90, 25, 0), 4, 2, 15, 75);
	CreateDoors((-280, -1482, 186), (-220, -1602, 186), (90, 25, 0), 4, 2, 15, 75);
	CreateBlocks((385, -1660, 40), (0, 120, 90));
	CreateRamps((-597, -280, 212), (-332, -522, 180));
	CreateRamps((726, -389, 142), (560, -373, 13));
	CreateRamps((2250, -1155, 306), (1905, -876, 200));
	CreateRamps((850, -3125, 312), (535, -3125, 189));
	CreateRamps((1775, 450, 144), (1775, 735, -5));
	
	/* extra */
	CreateElevator((1986, -2364, 372), (1036, -2607, 340), (0, 180, 0));
	CreateElevator((935, -3022, 341), (1583, -603, 344), (0, 180, 0));
	CreateElevator((1980, -518, 329), (2497, 234, -125), (0, 180, 0));
	CreateElevator((2330, 1224, -79), (1612, -184, -127), (0, 180, 0));
	CreateElevator((-454, 1162, 25), (2616, -524, -127), (0, 180, 0));
	CreateElevator((-695, -267, 184), (2616, -524, -127), (0, 180, 0));
	CreateElevator((470, -39, -123), (2497, 234, -125), (0, 180, 0));
	CreateElevator((-395, 1772, 174), (2497, 234, -125), (0, 180, 0));
	CreateElevator((4234, 150, -127), (-447, -5, 60), (0, 180, 0));
	CreateWalls((3465, 241, -127), (3123, 241, 0));
	CreateWalls((3465, 241, -127), (3465, -127, 0));
	CreateWalls((3123, 241, -20), (3123, -127, 0));
	CreateWalls((3123, -127, -127), (3465, -127, 0));
	CreateWalls((3123, 241, -127), (3123, 130, -85));
	CreateWalls((3123, -127, -127), (3123, -10, -85));
	CreateDoors((3160, 130, -127), (3123, 50, -127), (90, 0, 0), 4, 2, 15, 75);
	CreateGrids((3465, 241, -10), (3505, -127, -5), (0, 0, 0));
	CreateGrids((3160, 241, -10), (3120, -127, -5), (0, 0, 0));
	CreateGrids((3120, 241, -10), (3505, 280, -5), (0, 0, 0));
	CreateGrids((3120, -127, -10), (3505, -170, -5), (0, 0, 0));
	CreateRamps((3250, 180, -127), (3430, 180, -10));
}

Rust()
{
//Original Map Created by Unknown, Map modded and fixed by [UD]Dan
 CreateBlocks((773, 1080, 258), (0, 90, 0));
 CreateRamps((745, 1570, 383), (745, 1690, 273));
 CreateDoors((565, 1540, 295), (653, 1540, 295), (90, 90, 0), 3, 2, 20, 60);
 CreateGrids((773, 1135, 258), (533, 1795, 258), (0, 0, 0));
 CreateGrids((695, 1795, 378), (533, 1540, 378), (0, 0, 0));

 CreateGrids((773, 1540, 498), (630, 1795, 498), (0, 0, 0));
 CreateRamps((560, 1795, 498), (560, 1600, 378));
 CreateWalls((790, 1795, 278), (790, 1540, 378));
 CreateWalls((790, 1795, 378), (790, 1630, 498));
 CreateRamps((790, 1560, 378), (1200, 1560, 378));
 CreateRamps((1200, 1560, 378), (1200, 1200, 378));
 CreateGrids((1100, 1200, 378), (1300, 1000, 378), (0, 0, 0));
 CreateWalls((1075, 1200, 378), (1140, 1200, 455));
 CreateWalls((1270, 1200, 378), (1325, 1200, 455));
 CreateDoors((1100, 1200, 378), (1200, 1200, 435), (90, 90, 0), 4, 1, 20, 80);

 CreateWalls((515, 1540, 278), (515, 1795, 498));
 CreateWalls((773, 1540, 278), (715, 1540, 378));
 CreateWalls((590, 1540, 278), (533, 1540, 378));
 CreateWalls((773, 1540, 398), (533, 1540, 428));
 CreateWalls((773, 1540, 458), (740, 1540, 498));
 CreateWalls((566, 1540, 458), (533, 1540, 498));

 CreateGrids((773, 1540, 498), (630, 1795, 498), (0, 0, 0));
 CreateWalls((773, 1540, 498), (533, 1540, 538));
 CreateRamps((560, 1795, 498), (560, 1569, 378));
 CreateDoors((670, 1720, 498), (560, 1720, 498), (0, 0, 0), 2, 1, 20, 80);
 
 CreateWalls((790, 1795, 498), (790, 1540, 660));
 CreateWalls((515, 1540, 498), (515, 1795, 660));
 CreateRamps((560, 1550, 498), (560, 1795, 620));
 CreateDoors((670, 1690, 620), (560, 1690, 610), (0, 0, 0), 2, 1, 25, 80);
 CreateGrids((773, 1540, 620), (630, 1795, 620), (0, 0, 0));
 CreateWalls((773, 1540, 620), (533, 1540, 660));

 CreateWalls((773, 1540, 725), (533, 1540, 726));
 CreateWalls((790, 1795, 725), (790, 1540, 726));
 CreateWalls((515, 1540, 725), (515, 1795, 726));
}

Scrapyard()
{
	CreateRamps((132.356, 724.151, 47.2148),(136.437, 1167.86, 167.865));
	CreateRamps((281.099, 125.773, -4.94559),(845.572, 109.341, -105.434));
	CreateAsc((-1380.86, 466.875, 6.125),(-1377.76, 462.576, 126.357),0,4);
	CreateGrids((-1744.4, -81.9854, 87),(-1454.2, 77.6421, 87));
	CreateRamps((-1447.7, -108.6, 87.28),(-1737.23, -111.587, 87.28));
	CreateRamps((-1346.26, -107.479, 131.15),(-1437.92, -106.231, 91.3637));
	CreateRamps((-1733.02, 788.361, 87.28),(-1717.26, 99, 87.28));
	CreateDoors((-1578.1, -130.875, -127.875),(-1453.8, -133.461, -127.875),(90, 90, 0),3,2,50,90);
	CreateWalls((-1264.12, 607.126, -74.646),(-1267.54, 728.474, -68.3372));
	CreateWalls((-1265.44, 728.378, -125.875),(-1259.08, 607.125, -98.2332));
	CreateDoors((-1585.87, 847.775, -127.875),(-1487.21, 847.974, -127.875),(90, 90, 0),3,2,50,90);
}

Skidrow()
{
        CreateRamps((-1025, -666, 0 ), (-2243, -846, 787));
        CreateRamps((-2243, -846, 787), (-2239, -680, 834));
	CreateDoors((-2400, -663, 856), (-2150, -663, 856), (90, 90, 0), 7, 2, 20, 150);
        CreateRamps((-2223, -207, 837), (-2201, 61, 720));
        CreateRamps((-1351, -41, 702), (-1065, 191, 555));
        CreateRamps((-574, -343, 576), (-575, -438, 616));
        CreateRamps((-792, 208, 556), (-795, 393, 472));
	CreateElevator((-11, 583, 463), (-2599, -1422, 992));
	CreateElevator((8, 674, 463), (-631, 1042, 140));
        CreateRamps((-2585, -985, 992), (-2298, -976, 1158));
	CreateGrids((-2288, -800, 1158), (-2103, -1159, 1158), (0, 0, 0));
	CreateDoors((-1543, 1000, 128), (-1543, 1172, 140), (90, 0, 0), 15, 2, 20, 150);
	CreateElevator((-2070, 1176, 122), (-877, -980, 727));

}
Storm()
{
        CreateElevator((1444, 1344, 0), (1891, 466, 0), (0, 0, 0));

	CreateWalls((3000, -1328, -63), (3000, -1230, 150));
	CreateWalls((3000, -975, -63), (3000, -1075, 150));
	CreateDoors((3000, -975, -63), (3000, -1150, -63), (90, 90, 0), 5, 2, 50, 50);
	CreateGrids((3000, -1328, 150), (2700, -975, 150), (0, 0, 0));
        CreateRamps((2650, -975, -63), (2650, -1100, 150));
}

SubBase()
{
    CreateElevator((-271, -2175, 8), (1740, -2620, 0), (0, 270, 0));
    CreateElevator((1525, -2620, 0), (1660, -2380, 0), (0, 180, 0));
    CreateWalls((1765, -4341, 0), (1765, -4880, 130));
    CreateWalls((1495, -4341, 0), (1495, -4880, 130));
    CreateWalls((1765, -4341, 130), (1765, -4880, 180));
    CreateWalls((1765, -4341, 130), (1495, -4341, 180));
    CreateDoors((1400, -4340, -30), (1640, -4340, -30), (90, 90, 0), 7, 2, 30, 150);
    CreateGrids((1495, -4528, 130), (1765, -4340, 130), (0, 0, 0));
    CreateRamps((1690, -4750, -5), (1690, -4540, 125));
    CreateWalls((-830, -1350, 265), (-830, -1275, 330));
    CreateWalls((1495, -4341, 0), (1540, -4341, 130));
    CreateDoors((-1630, -1200, 290), (-1570, -1200, 295), (90, 90, 0), 7, 2, 40, 150);
    CreateRamps((805, -930, 272), (805, 40, 300));
    CreateWalls((1100, -1040, 270), (1100, -1120, 330));
    CreateWalls((890, -925, 270), (1000, -925, 330));
    CreateDoors((670, -905, 218), (808, -905, 315), (90, 90, 0), 4, 2, 30, 100);
    CreateWalls((640, -925, 270), (720, -925, 310));
    CreateWalls((890, -1500, 270), (1000, -1500, 330));
    CreateWalls((640, -1500, 270), (720, -1500, 330));
    CreateWalls((1765, -3400, 5), (1498, -3400, 33));
    CreateWalls((1498, -3600, 5), (1765, -3600, 33));
    CreateWalls((1765, -3800, 5), (1498, -3800, 33));
    CreateWalls((1498, -4000, 5), (1765, -4000, 33));
    CreateWalls((1785, -2600, 5), (1785, -4200, 55));
    CreateWalls((1478, -2600, 5), (1478, -4200, 55));
	CreateForce((1478, -2600, 56), (1478, -4200, 82));
	CreateForce((1785, -2600, 56), (1785, -4200, 75));
	CreateForce((-1380, -912, 287), (-1245, -912, 320));
	CreateWalls((1100, -1355, 300), (1100, -1268, 340));
	CreateElevator((1190, -7551, 16), (1190, -3960, 457), (0, 270, 0));
	CreateForce((585, -915, 270), (585, -1460, 340));
}

Terminal()
{

CreateRamps((642.105, 5649.42, 192.125),(917.875, 5648.44, 345.329));
CreateRamps((917.27, 5560.11, 354.873),(528.128, 5560.44, 421.616));
CreateRamps((1511.37, 6391.13, 425.378),(528.125, 6389.15, 429.343));
CreateBlocks((-193.253, 6198.4, 338.006),(0, 135.665, 0));
CreateBlocks((446.739, 6326.6, 440.983),(0, 268.308, 0));
CreateBlocks((436.931, 6327.95, 454.533),(0, -89.9506, 0));
CreateBlocks((428.444, 6327.85, 468.229),(0, -89.3738, 0));
CreateBlocks((419.407, 6328.67, 479.918),(0, -88.0719, 0));
CreateBlocks((405.046, 6329.9, 492.882),(0, -87.0557, 0));
CreateBlocks((392.839, 6329.16, 502.944),(0, -84.0179, 0));
CreateBlocks((239.767, 6359.71, 516.018),(0, 179.544, 0));
CreateBlocks((52.9467, 6359.54, 519.379),(0, 179.962, 0));
CreateElevator((-380.756, 6010.22, 351.125),(-527.618, 6398.83, 595.985));
CreateElevator((-791.55, 6641.43, 448.125),(86.9656, 6474.14, 192.125));

CreateElevator((420.868, 6573.77, 213.625),(576.427, 5376.65, 460.125));
CreateElevator((1489.22, 6390.62, 440.593),(573.506, 5250.68, 460.125));
CreateForce((686.825, 4754.96, 376.125),(695.052, 5447.88, 597.142));
CreateForce((-18.0474, 4776.98, 377.137),(-16.0702, 5478.88, 671.875));
CreateElevator((26.4599, 5028.42, 460.125),(-426.461, 5030.91, 368.125));
CreateForce((917.875, 5603.8, 346.221),(768.272, 5607.31, 445.933));
CreateWalls((-358.875, 5200.13, 377.125),(-519.874, 5199.11, 379.839));

CreateDoors((926, 5745, 368),(926, 5655, 368), (90, 0, 0), 2, 2, 20, 100);
CreateDoors((385, 6021, 456),(490, 6021, 456), (90, 90, 0), 4, 2, 15, 110);
CreateDoors((200, 6540, 255),(260, 6540, 255), (90, 90, 0), 2, 1, 20, 75);


CreateBlocks((384.621, 6357.57, 287.522),(0, -0.758057, 0));
CreateBlocks((334.322, 6353.94, 272.023),(0, 1.99402, 0));
CreateBlocks((277.35, 6362.23, 286.35),(0, -0.466919, 0));
CreateBlocks((225.99, 6356.82, 273.318),(0, 0.401001, 0));
CreateBlocks((172.84, 6362.8, 291.121),(0, 1.1261, 0));
CreateBlocks((132.632, 6357.61, 266.66),(0, 0.109863, 0));
CreateBlocks((95.0628, 6363.27, 218.677),(0, 0.109863, 0));
CreateBlocks((86.8758, 6356.82, 265.591),(0, 0.401001, 0));

CreateWalls((526.12, 6591.62, 200.125),(526.578, 6626.38, 277.375));
CreateWalls((500.732, 6687.48, 220),(507.512, 6839.09, 219));

}
	
Underpass()
{
	CreateElevator((-415, 3185, 392), (-1630, 3565, 1035), (0, 180, 0));
	CreateBlocks((1110, 1105, 632), (90, 0, 0));
	CreateBlocks((-2740, 3145, 1100), (90, 0, 0));
	CreateBlocks((2444, 1737, 465), (90, 0, 0));
	CreateWalls((-1100, 3850, 1030), (-1100, 3085, 1160));
	CreateWalls((-2730, 3453, 1030), (-2730, 3155, 1150));
	CreateWalls((-2730, 3155, 1030), (-3330, 3155, 1180));
	CreateWalls((-3330, 3155, 1030), (-3330, 3890, 1180));
	CreateWalls((-3330, 3890, 1030), (-2730, 3890, 1180));
	CreateWalls((-2730, 3890, 1030), (-2730, 3592, 1150));
	CreateWalls((-2730, 3890, 1150), (-2730, 3155, 1180));
	CreateDoors((-2730, 3400, 1052), (-2730, 3522.5, 1052), (90, 180, 0), 4, 2, 20, 75);
	CreateRamps((-3285, 3190, 1125), (-3285, 3353, 1030));
	CreateRamps((-3285, 3855, 1125), (-3285, 3692, 1030));
	CreateGrids((-2770, 3190, 1120), (-3230, 3190, 1120), (0, 0, 0));
	CreateGrids((-2770, 3855, 1120), (-3230, 3855, 1120), (0, 0, 0));
	CreateGrids((-2770, 3220, 1120), (-2770, 3825, 1120), (0, 0, 0));
	//CreateCluster(20, (-3030, 3522.5, 1030), 250);
	CreateElevator((-2689,-52, 2190), (-1630, 3565, 1035), (0, 180, 0));
	CreateElevator((2578, 3274, 390),(-2901, -411, 2156), (0, 180, 0));
}

Wasteland()
{
CreateWalls((9833, 6217, 175), (9593, 6216, 215));
CreateWalls((9593, 6216, 309), (9832, 6212, 249));


CreateWalls((9547, 6334, 175), (9547, 6510, 215));
CreateWalls((9547, 6334, 309), (9547, 6573, 249));


mgTurret1 = spawnTurret( "misc_turret", (9660, 6380, 230), "pavelow_minigun_mp" ); 
mgTurret1 setModel( "weapon_minigun" );
mgTurret1.angles = (0, 180, 0); 
CreateElevator((9850, 6590, 170), (10648, 10140, 304), (0, 180, 0));
CreateDoors((9542, 6383, 190), (9548, 6545, 190), (90,0, 0), 2, 2, 50, 75);

CreateGrids((7897, 6262, 49), (7576, 6632, 49), (0, 0, 0));
CreateRamps((7914, 6404, 40), (9449, 6419, 151));
CreateRamps((7914, 6444, 40), (9449, 6459, 151));

/*Out*/
CreateRamps((9432, 9030, 140), (9432, 6500, 140));
CreateRamps((9928, 9170, 166), (9928, 9655, 292));
CreateRamps((9992, 9681, 300), (9992, 8927, 344));

/*Walls and door for ramp*/
CreateWalls((10113, 8917, 366), (10036, 8917, 396));
CreateWalls((10113, 8917, 436), (10036, 8917, 466));
CreateDoors((10068, 8894, 372), (9991, 8894, 372), (90,90, 0), 1, 2, 50, 75);
CreateWalls((9945, 8917, 366), (9629, 8917, 396));
CreateWalls((9945, 8917, 436), (9629, 8917, 466));

/* Walls for protect for flags or ramp  */
CreateWalls((10725, 10237, 312), (9793, 10237, 342));
CreateWalls((10725, 10237, 382), (9793, 10237, 412));

CreateWalls((10794, 10003, 312), (10794, 9646, 342));
CreateWalls((10794, 10003, 382), (10794, 9646, 412));

CreateWalls((9792, 10236, 312), (9792, 9500, 342));
CreateWalls((9792, 10236, 382), (9792, 9500, 412));

/*Flags to go to out of map*/

CreateElevator((-3086, 2012, 34), (7711, 6431, 63), (0, 0, 0));
CreateElevator((-2262, -1354, 30), (7625, 6319, 63), (0, 0, 0));
CreateElevator((-475, -2091, 36), (7625, 6408, 63), (0, 0, 0));
CreateElevator((-3731, -1657, -37), (7625, 6491, 63), (0, 0, 0));
CreateElevator((2973, 781, -133), (7625, 6573, 63), (0, 0, 0));
CreateElevator((851, -487, -44), (7746, 6431, 63), (0, 0, 0));

}

Carnaval()
{
CreateWalls((760, -1085, -49), (1015, -1281, 83));
CreateRamps((945, -1121, 111), (1436, -499, -79));
CreateBlocks((1048, -1201, 126), (0, 90, 0));
CreateBlocks((824, -1027, 126), (0, 90, 0));
mgTurret1 = spawnTurret( "misc_turret", (1100, -1298, 344), "pavelow_minigun_mp" );
mgTurret1 setModel( "weapon_minigun" );
mgTurret1.angles = (0, 45, 0);
mgTurret1 = spawnTurret( "misc_turret", (728, -996, 344), "pavelow_minigun_mp" );
mgTurret1 setModel( "weapon_minigun" );
mgTurret1.angles = (0, 45, 0);
CreateRamps((735, -1078, 284), (1024, -1304, 284));
CreateRamps((897, -1210, 284), (449, -1787, -68));
CreateWalls((-327, -106, 58), (-395, -63, -65));
CreateWalls((-516, -134, 60), (-465, -76, -65));
CreateWalls((-1092, -877, 60), (-1153, -938, -65));
CreateWalls((1224, -2222, -43), (1589, -1760, 204));
mgTurret1 = spawnTurret( "misc_turret", (922, -1111, 134), "pavelow_minigun_mp" );
mgTurret1 setModel( "weapon_minigun" );
mgTurret1.angles = (0, 45, 0);
CreateElevator((235, -1098, 80), (237, -1051, 144), (0, 0, 0));
CreateElevator((410, -600, -62), (476, -965, -57), (0, 0, 0));

}

Salvage()
{
	CreateBlocks((1939.47,254.955,108.25), (0,90,0));
	CreateBlocks((1939.5,208.948,108.125), (0,90,0));
	CreateDoors((2368.87,30,17.9268), (2368.87,100,17.9268), (90, 0, 0), 3, 2, 35, 75);
	
	CreateBlocks((2052,1984,65), (90,90,0)); CreateBlocks((1992,1984,65), (90,90,0));
	CreateBlocks((1852,1988,180), (90,90,0)); CreateBlocks((1794,1988,180), (90,90,0));
	
	CreateDoors((1800,2365,5) , (1863,2365,5),(90, 90, 0), 2, 2, 35, 75);
	
	CreateBlocks((1598,2056,65), (90,0,0));
	
	CreateBlocks((4245,2086,32), (0,0,0));
	CreateBlocks((2546.82, 248.022, 66.7187),(0, 90, 0));

	CreateRamps((1147, 2896, 67), (1702, 2896, 254));
	CreateGrids((1732, 2796, 260), (1932, 2996, 260), (0, 0, 0));
	CreateDoors((1783, 3120, 300), (1783, 2894, 300), (90, 0, 0), 9, 2, 15, 197);
	CreateElevator((1370, -710, 1), (1000, 2915, 85), (0, 0, 0));
	CreateElevator((1956, 2988, 258), (1832, 2473, 430), (0, 180, 0));
	CreateGrids((1832, 2473, 395), (1653, 2517, 395), (0, 0, 0));


	CreateElevator((2364, 307, 255), (2967, 1238, 1), (0, 0, 0));
	CreateElevator((18, 44, 25), (3113, 1726, 1), (0, 0, 0));
	CreateElevator((3241, 935, 0), (1695, 24, 4), (0, 0, 0));
	CreateGrids((3500, 1400, 800), (3200, 1549, 800), (0, 0, 0));
	CreateAsc((3122, 1084, 161), (3142, 1073, 300),90,2);
	CreateAsc((3325, 905, 318), (3325, 905, 644),90,2);
	CreateRamps((1993, 89, 108), (2137, 89, 199));
	CreateRamps((2976, -660, 1), (2584, -660, 257));
	CreateRamps((3556, 1245, 0), (3429, 922, 196));
	CreateRamps((3153, 984, 352), (3556, 1387, 800));
}

Bailout()
{ 
	CreateElevator((2678,  -3362, 572), (-550, -637, 384), (0, 180, 0));
	CreateElevator((-622,  -1216, 384), (-610, -1363, 384), (0, 180, 0));
	CreateElevator((-1000, -1600, 490), (2962, -3183, 600), (0, 180, 0));
	CreateElevator((2962,  -3490, 600), (-1050, -1400, 430), (0, 180, 0));
	CreateWalls((-752, -1327, 384), (-752, -1427, 490));
	CreateWalls((-752, -1700, 384), (-752, -1600, 490));
	CreateWalls((-752, -1600, 490), (-1072, -1600, 384));
	CreateGrids((-1000, -1600, 490), (-752, -1327, 490), (0, 0, 0));
	CreateDoors((-752, -1620, 384) , (-752, -1515, 384),(90, 0, 0), 6, 2, 35, 75);
	CreateRamps((-1050, -1600, 490), (-1050, -1450, 384));

	CreateDoors((278, -872, 400) , (198, -872, 400),(90, 90, 0), 6, 2, 35, 75);
	CreateElevator((180,  -1200, 400), (0, -3300, 2050), (0, 0, 0));

	CreateGrids((0, -3300, 2000), (400, -3000, 2000), (0, 0, 0));
	CreateGrids((100, -3300, 2120), (350, -3000, 2120), (0, 0, 0));
	CreateRamps((400, -3000, 2120), (400, -3200, 2000));
	CreateGrids((100, -3300, 2240), (350, -3000, 2240), (0, 0, 0));
	CreateRamps((400, -3000, 2240), (400, -3200, 2120));
        CreateDoors((400, -3320, 2240) , (400, -3030, 2240),(0, 0, 0), 3, 1, 30, 75);
	CreateWalls((100, -2980, 2000), (100, -3060, 2100));
	CreateWalls((100, -3320, 2000), (100, -3240, 2100));
        CreateDoors((100, -3320, 2000) , (100, -3150, 2000),(90, 0, 0), 6, 2, 35, 75);

}

Crash()
{
//Funky Edit Start
//Tidied by Dan (UD)

CreateRamps((804, -270, 415), (798, -576, 355));
CreateRamps((917, -289, 415), (498, -289, 415));
//CreateRamps((917, -283, 395), (827, -289, 403));
CreateRamps((760, -345, 565), (542, -345, 415));
//added block by ramp
 CreateBlocks((515, -345, 415), (0, 90, 0));

CreateGrids((769, -350, 555), (899, -275, 555), (0, 0, 0));
CreateGrids((927, -281, 555), (1013, -274, 555), (0, 0, 0));
CreateElevator((1029, -281, 555), (1120, -1568, 244), (0, 0, 0));
CreateElevator((794, -1575, 244), (1779, -809, 71), (0, 0, 0));
CreateElevator((1790, -984, 207), (904, -284, 431), (0, 0, 0));
//deleted wall added 2 doors and new wall to defend flag
 CreateDoors((1562, -724, 284), (1562, -724, 215), (0, 0, 0), 2, 1, 15, 80);
 CreateBlocks((1587, -770, 230), (0, 0, 0)); 
 CreateDoors((1417, -787, 207), (1490, -787, 207), (90, 90, 0), 2, 2, 25, 60); 
 CreateWalls((1778, -823, 207), (1742, -823, 284));
//Funky Edit End

}

Strike()
{
        CreateElevator((-669, 1630, 0), (-1750, 1303, 14), (0, 180, 0));
        CreateElevator((-1500, 2950, 950), (-630, 2119, 16), (0, 180, 0));

	CreateWalls((-3522, 1608, 0), (-3527, 1521, 60));
	CreateWalls((-3529, 1247, 0), (-3523, 1320, 60));
	CreateDoors((-3522, 1580, 0), (-3522, 1408, 0),(90, 0, 0), 6, 2, 35, 75);
	CreateAsc((-3544.001, 1884.001, 0.200), (-3437.001, 1776.001, 734.200),90,2);
	CreateAsc((-2861.001, 1959.001, 680.200), (-2064.001, 1959.001, 653.200),90,2);

	CreateAsc((-2064.001, 2210.001, 672.200), (-1800.001, 2700.001, 830.200),90,2);
	CreateAsc((-1751.001, 2167.001, 672.200), (-1700.001, 2700.001, 830.200),90,2);
	CreateAsc((-1411.001, 2214.001, 672.200), (-1600.001, 2700.001, 830.200),90,2);
        CreateGrids((-1800, 2700, 820), (-1500, 3000, 820), (0, 0, 0));
	CreateWalls((-1820, 2800, 820), (-1700, 2800, 915));
	CreateWalls((-1480, 2800, 820), (-1600, 2800, 915));
	CreateDoors((-1750, 2800, 820), (-1650, 2800, 820),(90, 90, 0), 4, 2, 35, 100);

        CreateGrids((-1800, 2650, 950),(-1500, 2950, 950), (0, 0, 0));
	CreateAsc((-1650.001, 3000.001, 820.200),(-1650.001, 3000.001, 950.200),90,2);
	mgTurret1 = spawnTurret( "misc_turret", (-2934, 1564, 38), "pavelow_minigun_mp" );
	mgTurret1.angles = (0, 0, 0); 
	mgTurret1 setModel( "weapon_minigun" );
	mgTurret2 = spawnTurret( "misc_turret", (-2934, 1360, 31), "pavelow_minigun_mp" );
	mgTurret2.angles = (0, 0, 0); 
	mgTurret2 setModel( "weapon_minigun" );


}

Vacant()
{
        CreateElevator((-86, -187, -47), (-1705, -7208, -116), (0, 0, 0));
	CreateDoors((-2019, -8515 ,-19) , (-1737,-8492,-19),(90, 90, 0), 6, 2, 15, 75);
	CreateWalls((-1649, -8752, -19), (-1647, -8515, 40));
	CreateWalls((-1612, -8768, -19), (-1435, -8778, 40));
	CreateDoors((-1435, -8778, -19) , (-1347, -8778, -19),(90, 90, 0), 3, 2, 10, 75);
	CreateRamps((-492, -8302, 235), (-756, -8302, 116));
	CreateWalls((-1380, -8491, 252), (-1943, -8489, 310));
	CreateDoors((-1943, -8489, 252) , (-2014, -8481, 252),(90, 90, 0), 5, 2, 15, 75);
        CreateElevator((-2302, -8286, 252), (-4926, -6881, 150), (0, 180, 0));
	CreateRamps((-5769, -6881, 365), (-4963, -6881, 84));

	CreateWalls((-5965, -5925, 372), (-5965, -6300, 450));
	CreateWalls((-5965, -6300, 450), (-6249, -6300, 342));
	CreateDoors((-6249, -6300, 372) , (-6347, -6300, 372),(90, 90, 0), 5, 2, 15, 75);
	CreateGrids((-5965, -5925, 472), (-6347, -6300, 472), (0, 0, 0));
	CreateRamps((-6388, -6151, 472), (-6379, -5976, 372));


}