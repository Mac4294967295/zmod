#include maps\mp\gametypes\_rank;

//Returns the number of the next spawn that is nulled, don't set spawns on 0/0/0
GetSpawnPoint(team)
{
	if(team == "humans")
	{
		team = 0;
	}
	else if(team == "zombies")
	{
		team = 1;	
	}
	else
	{
		return 0;
	}
	
	for(counter = 0; counter <= 49; counter++)
	{
		if(level.arraySpawnPoint[team][counter][0] == 0 && level.arraySpawnPoint[team][counter][1] == 0 && level.arraySpawnPoint[team][counter][2] == 0)
		{
				return counter;		
		}
	}
}

//sets all spawnpoint x/y/z cords to 0
NullSpawnPoints()
{
	for(i = 0; i <= 49; i++)
	{
		level.arraySpawnPoint[0][i][0] = 0;
		level.arraySpawnPoint[0][i][1] = 0;
		level.arraySpawnPoint[0][i][2] = 0;
		level.arraySpawnPoint[0][i][3] = 0;
		level.arraySpawnPoint[1][i][0] = 0;
		level.arraySpawnPoint[1][i][1] = 0;
		level.arraySpawnPoint[1][i][2] = 0;
		level.arraySpawnPoint[0][i][3] = 0;
	}
}

//adds spawnpoint to arraySpawnPoint
SetSpawnPoint(team, x_cord, y_cord, z_cord, angle)
{	
	spawnpoint = GetSpawnPoint(team);
	//iPrintLn("Spawnpoint: " + spawnpoint + "Team: " + team);
	
	if(spawnpoint < getdvarInt("max_spawnpoints_perteam") - 1)
	{
		if(team == "humans")
		{
			team = 0;
		}
		else if(team == "zombies")
		{
			team = 1;
		}
		
		level.arraySpawnPoint[team][spawnpoint][0] = x_cord;
		level.arraySpawnPoint[team][spawnpoint][1] = y_cord;
		level.arraySpawnPoint[team][spawnpoint][2] = z_cord;
		level.arraySpawnPoint[team][spawnpoint][3] = angle;
		
		//iPrintLn("X: " + level.arraySpawnPoint[team][spawnpoint][0] + " Y: " + level.arraySpawnPoint[team][spawnpoint][1] + " Z: " + level.arraySpawnPoint[team][spawnpoint][2] + " A: " + level.arraySpawnPoint[team][spawnpoint][3]);
		//wait 2;
	}
}

//spawns player on random team spawnpoint
SpawnPlayer()
{	
	//iPrintLn("I AM A : " + self.isZombie);
	team = 0;
	nameteam = 0;
	
	if(self.isZombie == 0)
	{
		team = 0;
		nameteam = "humans";
	}
	else if(self.isZombie != 0)
	{
		team = 1;
		nameteam = "zombies";
	}
	
	randspawn = randomInt(GetSpawnPoint(nameteam));
	iPrintLn("Zombie: " + self.isZombie + " Team: " + team + " randspawn: " + randspawn + " GetSpawnPoint:" + GetSpawnPoint(nameteam));
	iPrintLn("x: " + level.arraySpawnPoint[team][randspawn][0] + " y: " + level.arraySpawnPoint[team][randspawn][1] + " z: " + level.arraySpawnPoint[team][randspawn][2] + " a: " + level.arraySpawnPoint[team][randspawn][3]);
	
	//dont spawn if x/y/z = 0
	if( level.arraySpawnPoint[team][randspawn][0] != 0 && level.arraySpawnPoint[team][randspawn][1] != 0 && level.arraySpawnPoint[team][randspawn][2] != 0)
	{
		self setOrigin((level.arraySpawnPoint[team][randspawn][0], level.arraySpawnPoint[team][randspawn][1], level.arraySpawnPoint[team][randspawn][2]));
		self SetPlayerAngles( (0, level.arraySpawnPoint[team][randspawn][3], 0) );		
		//iPrintLn("Zombie: " + self.isZombie + " Team: " + team);
		//iPrintLn("randspawn " + randspawn + " / GetSpawn " + GetSpawnPoint(team));
		//iPrintLn("x: " + level.arraySpawnPoint[team][randspawn][0] + " y: " + level.arraySpawnPoint[team][randspawn][1] + " z: " + level.arraySpawnPoint[team][randspawn][2]);
		//wait 1;
	}
}

//cycles through all the map spawnpoints during intermission, uncomment in _rank to enable
TestSpawnpoints()
{	
	SetDvar("scr_zmod_intermission_time", "600");
	while(1)
	{
		while(level.gameState == "intermission")
		{					
			for(counter = 0; counter <= 1; counter++)
			{
				if(counter == 0)
				{
					team = 0;
					nameteam = "humans";
				}
				else
				{
					team = 1;
					nameteam = "zombies";
				}
				
				iPrintLn("Team: " + team + " Teamname:  " + nameteam + " Totalteamspawns: " + GetSpawnPoint(nameteam));
				wait 1.5;
				for(spawncounter = 0; spawncounter < GetSpawnPoint(nameteam); spawncounter++)	//Human Spawns
				{
					iPrintLn("Spawnpoint: Team: " + nameteam + " Number: " + spawncounter + " / " + (GetSpawnPoint(nameteam) - 1));
					iPrintLn("Spawnpointinfo (x, y, z, a): (" + level.arraySpawnPoint[team][spawncounter][0] + " ," + level.arraySpawnPoint[team][spawncounter][1] + " ," + level.arraySpawnPoint[team][spawncounter][2] + " ," + level.arraySpawnPoint[team][spawncounter][3] + ")");
					self setOrigin((level.arraySpawnPoint[team][spawncounter][0], level.arraySpawnPoint[team][spawncounter][1], level.arraySpawnPoint[team][spawncounter][2]));
					self SetPlayerAngles( (0, level.arraySpawnPoint[team][spawncounter][3], 0) );
					wait 4; //Time to test each spawnpoint
				}
			}
		}
		wait 0.1;
	}
}

//creates the array, nulls all data, loads spawns
InitializeSpawnPoints()
{	
	//[humans/Zombie][Spawnpoint#][x_cord / y_cord / z_cord / angle]
	setup_dvar("max_spawnpoints_perteam", "50");
	level.arraySpawnPoint[2][getdvarInt("max_spawnpoints_perteam")][4] = [];
	NullSpawnPoints();
	LoadSpawnPoints();
}

//function that prints player cords and angle; uncomment function call in _rank to enable
//the middle number in Angles in the one necessary for SetSpawnPoint and SetSpawnZone
CollectSpawnCords()
{
	//intermission time in seconds
	SetDvar("scr_zmod_intermission_time", "300");
	
	while(1)
	{
		iPrintLn("Coords: " + self getOrigin() + " Angles: " + self GetPlayerAngles());
		wait 1.5;
	}
}

//Creates spawnpoints between point1 x/y and point 2 x/y; make sure numspawn (number of spawns) doesn't overflow arraySpawnPoint
SetSpawnZone(team, point1_x, point1_y, point2_x, point2_y, height, angle, numspawns)
{
	playersize = 50;
	xdiff = 0;
	ydiff = 0;
	
	//calculates the differences between the x/y cords of the two points
	if(point1_x >= point2_x)
	{
		xdiff = point1_x - point2_x;
	}
	else if(point2_x >= point1_x)
	{
		xdiff = point2_x - point1_x ;
	}
	if(point1_y >= point2_y)
	{
		ydiff = point1_y - point2_y;
	}
	else if(point2_y >= point1_y)
	{
		ydiff = point2_y - point1_y;
	}

	maxrows = int(xdiff / playersize);
	maxcolumns = int(ydiff / playersize);
	maxspawns = maxrows * maxcolumns;
	
	//when numspawns 0 set it to maxspawns
	if(numspawns == 0)
	{
		numspawns = maxspawns;
	}
	//if numspawn is greater then max possible spawns set it to maxspawns
	if(numspawns > maxspawns)
	{
		numspawns = maxspawns;
	}
	
	//if numspawns is greater then the available space in the arraySpawnPoint set it to max possible
	if(numspawns > getdvarInt("max_spawnpoints_perteam") - GetSpawnPoint(team))
	{
		numspawn = getdvarInt("max_spawnpoints_perteam") - GetSpawnPoint(team);
	}
	
	createdspawns = 0;
		

	//creates the spawnpoints from point1_x to point2_x and from point1_y to point2_y
	for(rowcounter = 0; rowcounter < maxrows && createdspawns < maxspawns && createdspawns < numspawns; rowcounter++)
	{		
		for(columncounter = 0; columncounter < maxcolumns && createdspawns < maxspawns && createdspawns < numspawns; columncounter++)
		{			
			if(point1_x > point2_x)
			{
				if(point1_y > point2_y)
				{
					SetSpawnPoint(team, point1_x - columncounter * playersize , point1_y - rowcounter * playersize , height, angle);
				}
				else if(point2_y > point1_y)
				{
					SetSpawnPoint(team, point1_x - columncounter * playersize , point1_y + rowcounter * playersize, height, angle);
				}		
			}
			else if(point2_x > point1_x)
			{
				if(point1_y > point2_y)
				{
					SetSpawnPoint(team, point1_x + columncounter * playersize , point1_y - rowcounter * playersize , height, angle);
				}
				else if(point2_y > point1_y)
				{
					SetSpawnPoint(team, point1_x + columncounter * playersize , point1_y + rowcounter * playersize, height, angle);
				}
			}
			createdspawns++;
		}
	}		
}

//loads all spawnpoints/zones of the current map
LoadSpawnPoints()
{	
	//SetSpawnPoint creates a single spawnpoint for a team on a coordinate; parameters (without []): SetSpawnPoint("[humans/zombies]", [x_coordinate], [y_coordinate], [z_coordinate], [player angle/view direction]);
	//SetSpawnZone creates one or multiple spawnpoints for a team on a 2D plain between 2 points; parameters (without []): SetSpawnZone([humans/zombies]", [x_coordinate point 1], [y_coordinate point 1], [x_coordinate point 2], [y_coordinate point 2], [z_coordinate], [player angle/view direction], [number of spawns (0 = max possible)]);
	//Use CollectSpawnCords() to collect coordinates / angles
	
	//SetSpawnPoint("humans", 100, 100, 100, 100);
	//SetSpawnZone("zombies", 100, 100, 100, 100, 100, 100, 10);
	//Note: if a spawnpoints x/y/z coordinates are all 0, the spawn will not work and all spawns loaded after it will not work either
	
	switch(getDvar("mapname"))
	{
		case "mp_rust":
			SetSpawnZone("humans", 770, 1480, 550, 1150, 295, -90, 10);
			SetSpawnPoint("zombies", -254, 1760, -236, 0);
			SetSpawnPoint("zombies", 1130, 1762, -228, 180);
			SetSpawnPoint("zombies", 1470, 1360, -236, -90);
			SetSpawnPoint("zombies", 1400, -160, -228, 180);
			SetSpawnPoint("zombies", 570, -20, -217, -90);
			SetSpawnPoint("zombies", -260, -70, -234, -32);
			SetSpawnPoint("zombies", -420, 940, -223, -90);
			
			break; 
		
		case "mp_afghan":	/** Afghan **/
			//Shit map edit		
			break;

		case "mp_boneyard":	/** Scrapyard **/
			//Shit map edit	
			break;

		case "mp_trailerpark":	/** trailerpark **/
			//no map
			break;

		case "mp_brecourt":	/** Wasteland **/
			//Shit map edit
			break;

		case "mp_checkpoint":	/** Karachi **/
			//Great Potential, Shit map edit
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
			//no map
			break;

		case "mp_highrise":	/** HighRise **/
			//Shit map edit	
			break;	

		case "mp_nightshift":	/** Skidrow **/
			//Shit map edit
			break;

		case "mp_storm":	/** Storm **/
			//no map
			break;

		case "mp_invasion":	/** Invasion **/
			//SetSpawnZone("humans", 670, -1460, 520, -1260, 292, -160, 0);	//12
			SetSpawnZone("humans", -3360, -2670, -3110, -2870, 267, 0, 0);	//20
			
			SetSpawnPoint("zombies", -560, 580, 250, -75);
			SetSpawnPoint("zombies", 1990, -2470, 290, 140);
			SetSpawnPoint("zombies", 40, -3700, 244, 90);
			SetSpawnPoint("zombies", -2220, -3810, 268, 90);
			SetSpawnPoint("zombies", -3600, -1240, 260, 0);
			SetSpawnPoint("zombies", -1800, -580, 274, -90);
			SetSpawnPoint("zombies", -50, -2500, 260, 135);
			break;

		case "mp_quarry":	/** Quarry **/
			
			break;

		case "mp_rundown":	/** Rundown **/
			
			break;

		case "mp_subbase":	/** SubBase **/
			
			break;

		case "mp_terminal":	/** Terminal **/
			SetSpawnZone("humans", 700, 6400, 900, 6000, 195, -90, 10); //Shitspawns
			
			SetSpawnPoint("zombies", 255, 4730, 46, -90);
			SetSpawnPoint("zombies", 1500, 2850, 42, -180);
			SetSpawnPoint("zombies", 2070, 2980, 42, 0);
			SetSpawnPoint("zombies", -250, 4870, 195, 60);
			SetSpawnPoint("zombies", 1000, 5200, 195, 0);
			SetSpawnPoint("zombies", 1620, 7080, 195, 180);
			SetSpawnPoint("zombies", 2850, 4970, 195, 180);
			
			break;

		case "mp_underpass":	 /** Underpass **/
			
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