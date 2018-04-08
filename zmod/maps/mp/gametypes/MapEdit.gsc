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
			if(Distance(enter, player.origin) <= 35){
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
			CreateElevator((-3055, 3250, 230), (-2271, 1600, -92), (0, 90, 0));
			CreateElevator((-2326, 1428, -100), (-3058, 3227, 370), (0, -90, 0));

			CreateRamps((-2397, 1856, 120), (-2280, 1856, 19));
			CreateGrids((-3000, 2857, 95), (-3350, 3300, 95), (0, 0, 0));// middle = debth
			CreateGrids((-3110, 3000, 220), (-3350, 3300, 220), (0, 0, 0));
			CreateGrids((-3000, 3000, 340), (-3240, 3300, 340), (0, 0, 0));//top one
			CreateRamps((-3300, 3030, 330), (-3300, 3200, 220));
			CreateDoors((-3300, 3300, 340), (-3300, 3150, 340), (0, 0, 0), 1, 1, 15, 80);


			CreateWalls((-3000, 3000, 100), (-3080, 3000, 340));
			CreateWalls((-3270, 3000, 100), (-3350, 3000, 340));
			CreateDoors((-3300, 3000, 150), (-3140, 3000, 150), (0, 0, 90), 1, 2, 15, 110);
			CreateWalls((-3000, 3300, 100), (-3000, 3000, 340));
			CreateWalls((-3000, 3300, 100), (-3350, 3300, 340));
			CreateWalls((-3350, 3300, 100), (-3350, 3000, 340));
			CreateRamps((-3050, 3050, 220), (-3050, 3220, 100));
			CreateWalls((-3000, 3000, 250), (-3350, 3000, 280));

			CreateWalls((-2354, 1869, -93), (-2445, 1869, -10));

			CreateForce((-2219, 2300, -105), (-2954, 2300, 45));
			CreateElevator((-2885, 2227, -14), (-3090, 2324, 115), (0, 90, 0));
			//CreateWalls((-2982, 2325, 103), (-2951, 2315, 160));

			CreateForce((-3037, 2331, 134), (-3037, 2820, 162));
			CreateForce((-3210, 2331, 134), (-3210, 2820, 162));

			//Arrow
			CreateBlocks((-2267, 2280, 27), (0, 0, 90));
			CreateBlocks((-2267, 2280, -3), (0, 0, 90));
			CreateBlocks((-2323, 2280, 27), (0, 0, 90));
			CreateBlocks((-2323, 2280, -3), (0, 0, 90));
			CreateBlocks((-2379, 2280, 27), (0, 0, 90));
			CreateBlocks((-2379, 2280, -3), (0, 0, 90));
			CreateBlocks((-2415, 2280, 21), (135, 0, 90));
			CreateBlocks((-2414, 2280, 3), (45, 0, 90));
			CreateBlocks((-2388, 2280, 49), (-45, 0, 90));
			CreateBlocks((-2388, 2280, -22), (45, 0, 90));

			CreateGrids((-3000, 2850, 220), (-3000, 2505, 220), (0, -90, 0));
			//Stairs
			CreateBlocks((-3332, 2884, 217), (0, 0, 0));
			CreateBlocks((-3332, 2899, 232), (0, 0, 0));
			CreateBlocks((-3332, 2914, 247), (0, 0, 0));
			CreateBlocks((-3332, 2929, 262), (0, 0, 0));
			CreateBlocks((-3332, 2944, 277), (0, 0, 0));
			CreateBlocks((-3332, 2959, 292), (0, 0, 0));
			CreateBlocks((-3332, 2974, 307), (0, 0, 0));
			CreateBlocks((-3332, 2989, 322), (0, 0, 0));
			CreateBlocks((-3332, 3001, 325), (0, 0, 0));
			CreateBlocks((-3300, 3001, 325), (0, 0, 0));
			break;

		case "mp_brecourt":	/** Wasteland **/
			//Shit map edit
			break;

		case "mp_checkpoint":	/** Karachi **/
			CreateElevator((561, 116, 176), (568, -67, 280), (0, 0, 0));
			CreateBlocks((479, -831, 369), (90, 90, 0));
			CreateRamps((559, -255, 554), (559, -99, 415));
			CreateRamps((-3718, -211, 600),(-3339, -211, 772));
			CreateRamps((-3905, -211, 600),(-4369, -211, 907));
			CreateElevator((202, -1046, 0), (-3791, -535, 600), (0, 90, 0));
			//CreateElevator((-1375, 137, 0), (-1851, 519, 808), (0, 0, 0)); //Tower
			CreateElevator((-5159, -637, 928), (-4905, 831, 792), (0, 78, 0));
			CreateRamps((-4467, 1311, 792),(-4070, 1311, 905));
			CreateRamps((-3058, 1072, 616),(-2797, 1072, 756));
			CreateAsc((-3268, 1120, 616),(-3268, 1355, 910), (0, -90, 0), 3);
			//CreateRamps((-649, 1893, 335),(-885, 1893, 300));

			//CreateRamps((-332, 664, 200), (-46, 561, 360));
			CreateRamps((-54, 550, 192), (-54, 759, 335));
			CreateRamps((-205, 759, 335), (-205, 570, 475));

			CreateBlocks((-47, 558, 483), (0, -90, 0));
			CreateBlocks((-77, 558, 483), (0, -90, 0));

			CreateBlocks((-47, 498, 483), (0, -90, 0));
			CreateBlocks((-77, 498, 483), (0, -90, 0));

			CreateBlocks((-47, 438, 483), (0, -90, 0));
			CreateBlocks((-77, 438, 483), (0, -90, 0));
			CreateElevator((-513, 852, 472), (-513, 852, 608), (0, 0, 0));
			CreateGrids((-172, 731, 614), (-40, 731, 614), (0, -90, 0));
			CreateGrids((-202, 731, 644), (-70, 731, 644), (0, -90, 0));
			CreateGrids((-232, 731, 674), (-100, 731, 674), (0, -90, 0));
			CreateGrids((-262, 731, 704), (-130, 731, 704), (0, -90, 0));
			CreateGrids((-292, 731, 734), (-160, 731, 734), (0, -90, 0));
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
			CreateBlocks((463, -16, 297), (180, -90, 90));
			CreateBlocks((463, 90, 297), (180, -90, 90));
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
			CreateElevator((2870, 5010, 193),(2980, 5010, 193), (0, 0, 0));
			CreateElevator((2870, 4610, 193),(3010, 4610, 193), (0, 0, 0));
			CreateWalls((3348, 2710, 200),(3734, 3230, 210));
			CreateWalls((3348, 2710, 250),(3734, 3230, 260));
			CreateBlocks((3729, 4570, 213),(90, 90, -90));
			CreateBlocks((3729, 4600, 213),(90, 90, -90));
			CreateBlocks((3729, 4630, 213),(90, 90, -90));
			CreateBlocks((3994, 4504, 224),(0, 0, 0));	//Hide
			CreateBlocks((3729, 4579, 283),(45, -90, 90));
			CreateBlocks((3729, 4620, 283),(135, -90, 90));
			CreateBlocks((3757, 4662, 264),(180, 0, 90));
			CreateBlocks((3817, 4662, 264),(180, 0, 90));
			CreateBlocks((3877, 4662, 264),(180, 0, 90));
			CreateBlocks((3913, 4662, 264),(180, 0, 90));
			CreateDoors((3848, 4501, 260),(3848, 4509, 244), (180, 0, 90), 1, 1, 30, 85);
			CreateBlocks((3720, 4425, 274),(-180, -90, 90));
			CreateBlocks((3720, 4264, 274),(-180, -90, 90));
			CreateBlocks((3720, 3863, 274),(-180, -90, 90));
			CreateBlocks((3835, 3630, 274),(180, 0, 90));
			CreateBlocks((3775, 3630, 274),(180, 0, 90));
			CreateBlocks((3732, 3656, 221),(180, -180, 90));
			CreateBlocks((3732, 3656, 266),(180, -180, 90));
			CreateBlocks((3732, 3740, 221),(180, -180, 90));
			CreateBlocks((3732, 3740, 266),(180, -180, 90));
			CreateDoors((3774, 3698, 266),(3774, 3698, 221), (-180, -90, -90), 1, 1, 30, 85);
			CreateBlocks((3646, 4195, 216),(-90, -90, 0));
			CreateBlocks((3646, 4195, 284),(-90, -90, 0));
			CreateBlocks((3646, 3937, 216),(90, -90, 0));
			CreateBlocks((3646, 3937, 284),(90, -90, 0));
			CreateBlocks((3619, 4166, 216),(90, -90, 90));
			CreateBlocks((3619, 4136, 216),(90, -90, 90));
			CreateBlocks((3619, 4106, 216),(90, -90, 90));
			CreateBlocks((3619, 4076, 216),(90, -90, 90));
			CreateBlocks((3619, 4046, 216),(90, -90, 90));
			CreateBlocks((3619, 4016, 216),(90, -90, 90));
			CreateBlocks((3619, 3986, 216),(90, -90, 90));
			CreateBlocks((3619, 3956, 216),(90, -90, 90));
			CreateBlocks((3619, 4166, 284),(90, -90, 90));
			CreateBlocks((3619, 4136, 284),(90, -90, 90));
			CreateBlocks((3619, 4106, 284),(90, -90, 90));
			CreateBlocks((3619, 4076, 284),(90, -90, 90));
			CreateBlocks((3619, 4046, 284),(90, -90, 90));
			CreateBlocks((3619, 4016, 284),(90, -90, 90));
			CreateBlocks((3619, 3986, 284),(90, -90, 90));
			CreateBlocks((3619, 3956, 284),(90, -90, 90));
			CreateBlocks((3867, 3543, 216),(90, -180, 0));
			CreateBlocks((3867, 3433, 216),(90, -180, 0));
			CreateBlocks((3867, 3543, 284),(90, -180, 0));
			CreateBlocks((3867, 3433, 284),(90, -180, 0));
			CreateBlocks((3867, 3488, 287),(180, -90, 90));
			CreateDoors((3867, 3487, 284), (3867, 3487, 216), (-90, -90, 90), 2, 1, 40, 100);
			CreateWalls((3871, 3364, 237), (4027, 3243, 238));
			CreateWalls((4067, 3195, 253), (4218, 3000, 254));
			CreateRamps((4000, 2748, 175),(3648, 2411, 350));
			CreateWalls((4403, 2961, 344), (4403, 2340, 345));
			CreateWalls((4446, 3232, 376), (4446, 3602, 347));
			CreateWalls((4055, 4030, 390), (3704, 4030, 391));
			CreateWalls((2939, 3208, 392), (3227, 3208, 393));
			CreateElevator((3945, 4720, 194),(4000, 4710, 194), (0, 0, 0));
			CreateElevator((3973, 4537, 194),(3915, 4537, 194), (0, 180, 0));
			CreateAsc((4061, 4604, 184), (4061, 4564, 350), (0, -90, 0), 3);
			CreateBlocks((4389, 2322, 277),(90, -180, 135));
			CreateBlocks((4287, 2347, 216),(90, -180, 135));
			CreateBlocks((4264, 2370, 216),(90, -180, 135));
			CreateBlocks((4241, 2393, 216),(90, -180, 135));
			CreateBlocks((4287, 2347, 284),(90, -180, 135));
			CreateBlocks((4264, 2370, 284),(90, -180, 135));
			CreateBlocks((4241, 2393, 284),(90, -180, 135));
			CreateBlocks((4145, 2398, 216),(-90, -90, 0));
			CreateBlocks((4115, 2398, 216),(-90, -90, 0));
			CreateBlocks((4085, 2398, 216),(-90, -90, 0));
			CreateBlocks((4055, 2398, 216),(-90, -90, 0));
			CreateBlocks((4145, 2398, 284),(-90, -90, 0));
			CreateBlocks((4115, 2398, 284),(-90, -90, 0));
			CreateBlocks((4085, 2398, 284),(-90, -90, 0));
			CreateBlocks((4055, 2398, 284),(-90, -90, 0));
			CreateBlocks((3866, 2336, 216),(-90, -90, 0));
			CreateBlocks((3896, 2336, 216),(-90, -90, 0));
			CreateBlocks((3866, 2336, 284),(-90, -90, 0));
			CreateBlocks((3896, 2336, 284),(-90, -90, 0));
			CreateBlocks((3966, 2391, 216),(-90, -90, 45));
			CreateBlocks((3943, 2368, 216),(-90, -90, 45));
			CreateBlocks((3920, 2345, 216),(-90, -90, 45));
			CreateBlocks((3966, 2391, 284),(-90, -90, 45));
			CreateBlocks((3943, 2368, 284),(-90, -90, 45));
			CreateBlocks((3920, 2345, 284),(-90, -90, 45));
			CreateWalls((4363, 2335, 217), (4363, 2030, 218));
			CreateWalls((4323, 2242, 260), (4323, 2030, 261));
			CreateBlocks((4383, 2034, 192),(0, 0, 0));
			CreateWalls((4260, 2335, 217), (3832, 2127, 218));
			CreateBlocks((4330, 2275, 194),(0, 90, 0));
			CreateBlocks((4255, 2311, 271),(180, 45, -90));
			CreateBlocks((3818, 2018, 263),(180, -90, -90));
			CreateBlocks((3818, 2078, 263),(180, -90, -90));
			CreateBlocks((3768, 2031, 266),(180, -180, -180));
			CreateBlocks((3768, 2061, 266),(180, -180, -180));
			CreateBlocks((3768, 2091, 266),(180, -180, -180));
			CreateBlocks((4392, 2002, 246),(-90, -90, 0));
			CreateBlocks((3945, 3641, 239),(-90, -90, 0));

			CreateForce((4202, 2423, 192), (4202, 2423, 290));
			CreateForce((4013, 2423, 192), (4013, 2423, 290));

			CreateForce((4345, 2355, 192), (4345, 2355, 290));
			CreateForce((3819, 2355, 192), (3819, 2355, 290));
			CreateForce((3755, 2355, 192), (3755, 2355, 290));
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
			CreateElevator((1160, 2865, 624),(729, 3044, 791), (0, -127, 0));
			CreateElevator((1166, 1873, 382),(-1864, 1152, 416), (0, 0, 0));
			CreateElevator((-3310, 541, 414),(-2907, -422, 2138), (0, 59, 0));
			CreateElevator((-3326, 1865, 415),(1574, 1270, 874), (0, 110, 0));
			CreateElevator((-1561, 1905, 1945),(797, -353, 632), (0, -120, 0));
			CreateDoors((-2521, 1859, 460), (-2521, 1859, 400), (90, 90, -90), 5, 2, 20, 120);
			CreateDoors((-2180, 549, 460), (-2180, 549, 400), (90, 90, -90), 5, 2, 20, 120);
			CreateRamps((1536, 1330, 863),(1226, 2173, 1016));
			CreateBlocks((1536, 1330, 863),(0, 20, 0));

			/*Bunker*/
			CreateWalls((57, 3114, 1032),(167, 3257, 1126));
			CreateWalls((-52, 2972, 1032),(-170, 3063, 1180));
			CreateWalls((48, 3348, 1072),(-170, 3063, 1180));
			CreateWalls((48, 3348, 1032),(167, 3257, 1180));
			CreateGrids((-160, 3055, 1126), (-37, 3418, 1126), (0, 322, 0));
			CreateRamps((489, 2969, 1032),(166, 3213, 1120));
			CreateBlocks((489, 2969, 1032), (0, 233, 0));
			CreateDoors((129, 3207, 1225),(129, 3207, 1150), (90, 322, 0), 3, 1, 20, 120);
			CreateWalls((89, 3154, 1130),(-52, 2972, 1174));
			CreateDoors((68, 3135, 1070),(-17, 3016, 1070), (0, 232, -90), 1, 2, 20, 110);
			CreateWalls((-52, 2972, 1032),(-167, 2821, 1180));
			CreateWalls((167, 3257, 1032),(265, 3384, 1180));
			CreateWalls((-74, 2990, 1124), (-192, 2838, 1120));
			CreateWalls((142, 3273, 1124), (239, 3402, 1120));
			CreateAsc((-93, 3550, 1019), (151, 3375, 1156),(0, -36, 0),3);

			CreateForce((663, 2921, 791),(617, 2960, 784));
			break;

		case "mp_abandon":	/** Carnaval **/

			break;

		case "mp_compact":	/** Salvage **/

			break;

		case "mp_complex":	/** Bailout **/

			break;

		case "mp_crash":	/** Crash **/
			//Thanks to [UD]Dan for his help
			CreateRamps((804, -270, 415), (798, -576, 355));
			CreateRamps((917, -289, 415), (498, -289, 415));
			CreateRamps((755, -345, 558), (542, -345, 415));
			CreateBlocks((515, -345, 415), (0, 90, 0));
			CreateGrids((769, -350, 555), (899, -275, 555), (0, 0, 0));
			CreateGrids((927, -281, 555), (1013, -274, 555), (0, 0, 0));
			CreateElevator((1029, -281, 555), (794, -1575, 244), (0, 0, 0));
			CreateBlocks((867, -1597, 255), (135, 0, -90));
			CreateBlocks((890, -1597, 278), (135, 0, -90));
			CreateBlocks((927, -1597, 293), (0, 0, -90));
			CreateBlocks((963, -1597, 293), (0, 0, -90));
			CreateBlocks((1000, -1597, 278), (-135, 0, -90));
			CreateBlocks((1033, -1597, 255), (-135, 0, -90));
			CreateElevator((1125, -1568, 244), (1779, -809, 71), (0, 110, 0));
			CreateDoors((1581, -725, 282), (1581, -725, 204), (180, 90, 90), 1, 1, 20, 85);
			CreateBlocks((1600, -769, 232), (0, 0, -90));
			CreateBlocks((1655, -769, 232), (0, 0, -90));
			CreateBlocks((1600, -801, 232), (0, 0, 0));
			CreateBlocks((1655, -801, 232), (0, 0, 0));
			CreateDoors((1490, -787, 290), (1490, -787, 222), (90, 90, 0), 2, 2, 30, 90);
			CreateBlocks((1581, -860, 230), (0, -90, 90));
			CreateBlocks((1581, -922, 230), (0, -90, 90));
			CreateBlocks((1581, -984, 230), (0, -90, 90));
			CreateBlocks((1450, -989, 205), (0, 0, 0));
			CreateBlocks((1616, -847, 205), (0, 0, 0));
			CreateWalls((1630, -670, 215), (1755, -524, 225));
			CreateWalls((1630, -670, 260), (1755, -524, 275));
			CreateElevator((1685, -663, 207), (904, -284, 431), (0, -160, 0));
			break;

		case "mp_strike":	/** Strike **/

			break;

		case "mp_vacant":	/** Vacant **/

			break;

		default:
			break;
	}
}
