#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
init()
{
	level.doCustomMap = 0;
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

	wait 5;

	level toggleCreateMapWait();
	level LoadMapEdit();
	level toggleCreateMapWait();

	level.gameState = "starting";
}

toggleCreateMapWait()
{
	if(level.CreateMapWait == 1)
	{
		level.TimerText destroy();
		level notify("CREATED");
		foreach(player in level.players)
		{
			player freezeControls(false);
			player VisionSetNakedForPlayer(getDvar("mapname"), 0);
		}
	}
	else
	{
		iprintln("Do");
		level.CreateMapWait = 1;
		level.TimerText = level createServerFontString( "objective", 1.5 );
		level.TimerText setPoint( "CENTER", "CENTER", 0, -100 );
		level.TimerText setText("^3Wait for the map to be created");
		foreach(player in level.players)
		{
			player freezeControls(true);
			player VisionSetNakedForPlayer("mpIntro", 0);
		}
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
			door = spawn("script_model", open + ((0, 30, 0) * offset) - ((83, 0, 0) * h));
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
					self.hp --;
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


LoadMapEdit()
{
	switch(getDvar("mapname"))
	{
		case "mp_rust": /** Rust **/
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
			break;

		case "mp_afghan":	/** Afghan **/
			//Shit map edit
			break;

		case "mp_boneyard":	/** Scrapyard **/
			//Shit map edit
			break;

		case "mp_trailerpark":	/** trailerpark **/
			//no map
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
			break;

		case "mp_brecourt":	/** Wasteland **/
			//Shit map edit
			break;

		case "mp_checkpoint":	/** Karachi **/
			//Great Potential, Shit map edit
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
			break;

		case "mp_derail":	/** Derail **/
			//good potential, broken map edit
			break;

		case "mp_estate":	/** Estate **/
			//Great Potential, Shit map edit
			break;

		case "mp_favela":	/** Favela **/
			//Great Potential, Shit map edit
			break;

		case "mp_fuel2":	/** Fuel **/
			//Hall
			CreateBlocks((1160, -432, 76), (90, -90, 0));
			CreateBlocks((1129, -432, 76), (90, -90, 0));
			CreateBlocks((1189, -666, 164), (180, -180, 90));
			CreateBlocks((1143, -666, 164), (180, -180, 90));
			CreateBlocks((1035, -729, 50), (180, -180, 90));
			CreateBlocks((1446, -317, 120), (180, 90, 90));
			CreateBlocks((1446, -237, 120), (180, 90, 90));
			CreateBlocks((1279, -163, 111), (180, -180, 90));
			CreateBlocks((1126, 39, 60), (-90, 135, 135));
			CreateBlocks((1096, 39, 60), (-90, 135, 135));
			CreateBlocks((1039, 39, 60), (-90, 135, 135));
			CreateBlocks((1009, 39, 60), (-90, 135, 135));
			CreateBlocks((1126, 39, 149), (-90, 135, 135));
			CreateBlocks((1096, 39, 149), (-90, 135, 135));
			CreateBlocks((1039, 39, 149), (-90, 135, 135));
			CreateBlocks((1009, 39, 149), (-90, 135, 135));
			CreateBlocks((952, -23, 100), (0, 90, -90));
			CreateBlocks((952, -96, 100), (0, 90, -90));
			CreateBlocks((1198, 378, 307), (0, 90, -90));
			CreateBlocks((1298, 424, 208), (0, -180, 90));
			CreateBlocks((1251, 424, 208), (0, -180, 90));
			CreateBlocks((1987, -153, -144), (90, -180, 180));
			CreateBlocks((1987, -183, -144), (90, -180, 180));
			CreateBlocks((1987, -213, -144), (90, -180, 180));
			CreateBlocks((1987, -243, -144), (90, -180, 180));
			CreateBlocks((616, -147, 320), (0, 0, 90));
			CreateBlocks((616, 284, 300), (0, 0, 90));
			CreateDoors((1420, -72, -220), (1600, -8, -170), (90, 135, 45), 5, 2, 40, 100);
			//House
			CreateBlocks((168, -1551, 107), (-90, -90, 0));
			CreateBlocks((915, -2416, -57), (-90, -90, -90));
			CreateBlocks((848, -1569, -212), (-90, -90, 0));
			CreateBlocks((818, -1569, -212), (-90, -90, 0));
			CreateBlocks((1004, -1989, -224), (0, -90, -90));
			CreateBlocks((1004, -1989, -179), (0, -90, -90));
			CreateBlocks((851, -1946, -203), (0, 0, -90));
			CreateBlocks((851, -1946, -173), (0, 0, -90));
			CreateWalls((200, -1750, -220), (345, -1810, -210));
			CreateWalls((200, -1750, -175), (345, -1810, -165));
			CreateWalls((345, -1810, -175), (586, -1810, -165));
			CreateBlocks((168, -1613, -192), (0, 90, 90));
			CreateBlocks((168, -1613, -162), (0, 90, 90));
			CreateBlocks((396, -1660, -192), (0, 0, 90));
			CreateBlocks((457, -1660, -133), (0, 0, 90));
			CreateDoors((614, -1552, -85), (614, -1602, -85), (90, 0, 180), 2, 2, 40, 60);
			CreateBlocks((600, -1681, -15), (180, 90, -90));
			CreateBlocks((540, -1923, -22), (180, 90, 90));
			CreateBlocks((540, -1863, -22), (180, 90, 90));
			CreateBlocks((479, -1740, -14), (0, 0, 0));
			CreateBlocks((653, -2180, -9), (0, 0, -90));
			CreateBlocks((653, -2210, -20), (0, 0, -90));
			CreateBlocks((865, -1933, 114), (0, 0, 90));
			CreateBlocks((798, -1564, 89), (0, 0, 0));
			break;

		case "mp_highrise":	/** HighRise **/
			//Shit map edit
			break;

		case "mp_nightshift":	/** Skidrow **/
			//Shit map edit
			break;

		case "mp_storm":	/** Storm **/
		CreateGrids((3520, -790, 460), (3730, -933, 460), (0, 0, 0));
		CreateGrids((3142, -935, 460), (3200, -1015, 460), (0, 0, 0));

		CreateBlocks((3130, -885, 611), (0, -90, 0));
		CreateBlocks((3130, -942, 611), (0, -90, 0));
		CreateBlocks((3220, -1413, 481), (0, 0, 0));
		CreateBlocks((3220, -1451, 481), (0, 0, 0));

		CreateBlocks((3490, -1413, 481), (0, 0, 0));
		CreateBlocks((3490, -1451, 481), (0, 0, 0));

		CreateBlocks((3762, -1413, 481), (0, 0, 0));
		CreateBlocks((3762, -1451, 481), (0, 0, 0));

		CreateBlocks((4074, -1413, 481), (0, 0, 0));
		CreateBlocks((4074, -1451, 481), (0, 0, 0));

		CreateWalls((3730, -967, 460), (3525, -967, 550));

		CreateElevator((1527, -600, -66), (2578, -747, 624), (0, 0, 0));


		CreateDoors((-2699, -3215, 220), (-2699, -3301, 220), (90, 0, 0), 3, 1, 20, 80);
		CreateElevator((-836, 463, -7.6), (-2398, -3406, 50), (0, 180, 0));
		CreateElevator((2627, -1151, -64), (49, -59, 0), (0, 140, 0));
		CreateElevator((-2176, -3151, 550), (49, -59, 0), (0, 140, 0));

		CreateWalls((-2615, -3210, 630), (-2618, -2985, 629));
		CreateBlocks((-2605, -2940, 584), (0, -90, 0));
		CreateBlocks((-2592, -3215, 584), (0, -90, 0));
			break;

		case "mp_invasion":	/** Invasion **/
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
			break;

		case "mp_quarry":	/** Quarry **/
			//high potential, shit mapedit
			break;

		case "mp_rundown":	/** Rundown **/
			//high potential, shitmapeditor
			break;

		case "mp_subbase":	/** SubBase **/
			//high potential, half thought out mapedit
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
			break;

		case "mp_terminal":	/** Terminal **/
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

			CreateDoors((926, 5745, 368),(926, 5655, 368), (90, 0, 0), 2, 2, 20, 100);
			CreateDoors((385, 6021, 456),(490, 6021, 456), (90, 90, 0), 4, 2, 15, 110);
			CreateDoors((200, 6540, 255),(260, 6540, 255), (90, 90, 0), 2, 1, 20, 75);

			CreateElevator((420.868, 6573.77, 213.625),(576.427, 5376.65, 460.125));
			CreateElevator((1489.22, 6390.62, 440.593),(573.506, 5250.68, 460.125));
			CreateForce((686.825, 4754.96, 376.125),(695.052, 5447.88, 597.142));
			CreateForce((-18.0474, 4776.98, 377.137),(-16.0702, 5478.88, 671.875));
			CreateElevator((26.4599, 5028.42, 460.125),(-426.461, 5030.91, 368.125));
			CreateForce((917.875, 5603.8, 346.221),(768.272, 5607.31, 445.933));
			CreateWalls((-358.875, 5200.13, 377.125),(-519.874, 5199.11, 379.839));

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
			break;

		case "mp_underpass":	 /** Underpass **/
		CreateBlocks((1020, 2763, 489),(0, 0, 0));
		CreateBlocks((1020, 2778, 504),(0, 0, 0));
		CreateBlocks((1020, 2793, 519),(0, 0, 0));
		CreateBlocks((1020, 2808, 534),(0, 0, 0));
		CreateBlocks((1020, 2823, 549),(0, 0, 0));
		CreateBlocks((1020, 2838, 564),(0, 0, 0));
		CreateBlocks((1020, 2853, 579),(0, 0, 0));
		CreateBlocks((1020, 2868, 594),(0, 0, 0));
		CreateElevator((1160, 2865, 624),(-1165, 2897, 424), (0, -90, 0));
		CreateElevator((-3310, 541, 414),(-2907, -422, 2138), (0, 59, 0));
		CreateElevator((-3326, 1865, 415),(1560, 1266, 876), (0, -106, 0));
		CreateDoors((-2521, 1859, 460), (-2521, 1859, 400), (90, 90, -90), 5, 2, 20, 120);
		CreateDoors((-2180, 549, 460), (-2180, 549, 400), (90, 90, -90), 5, 2, 20, 120);
		CreateRamps((1129, 948, 935),(1126, 656, 995));
		CreateBlocks((1129, 948, 940),(0, 0, 0));
			break;

		case "mp_abandon":	/** Carnaval **/

			break;

		case "mp_compact":	/** Salvage **/

			break;

		case "mp_complex":	/** Bailout **/

			break;

		case "mp_crash":	/** Crash **/

			break;

		case "mp_strike":	/** Strike **/

			break;

		case "mp_vacant":	/** Vacant **/

			break;

		default:
			break;
	}
}
