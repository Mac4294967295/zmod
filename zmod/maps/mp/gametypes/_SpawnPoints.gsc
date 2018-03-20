

//Returns the number of the next spawn that is nulled, don't set spawns on 0/0/0
GetSpawnPoint(team)
{
	if(team == "allies")
	{
		team = 0;
	}
	else if(team == "axis")
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

	if(team == "allies")
	{
		team = 0;
	}
	else if(team == "axis")
	{
		team = 1;
	}
	
	level.arraySpawnPoint[team][spawnpoint][0] = x_cord;
	level.arraySpawnPoint[team][spawnpoint][1] = y_cord;
	level.arraySpawnPoint[team][spawnpoint][2] = z_cord;
	level.arraySpawnPoint[team][spawnpoint][3] = angle;
}

//spawns player on random team spawnpoint
SpawnPlayer(team)
{	
	if(team == "allies")
	{
		team = 0;
	}
	else if(team == "axis")
	{
		team = 1;
	}
	randspawn = randomInt(GetSpawnPoint(self.pers["team"]));
	self setOrigin((level.arraySpawnPoint[team][randspawn][0], level.arraySpawnPoint[team][randspawn][1], level.arraySpawnPoint[team][randspawn][2]));
	self SetPlayerAngles( (0, level.arraySpawnPoint[team][randspawn][3], 0) );
	/*
	iPrintLn("Spawned");
	iPrintLn("Entry x: " + level.arraySpawnPoint[team][randspawn][0]);
	iPrintLn("Entry y: " + level.arraySpawnPoint[team][randspawn][1]);
	iPrintLn("Entry z: " + level.arraySpawnPoint[team][randspawn][2]);
	
	iPrintLn("randspawn " + randspawn + " / GetSpawn " + GetSpawnPoint(self.pers["team"]));
	*/
}

//creates the array, nulls all data, loads spawns
InitializeSpawnPoints()
{	
	//[Attackers/Defenders][Spawnpoint#][x_cord / y_cord / z_cord / angle]
	level.arraySpawnPoint[2][50][4] = [];
	NullSpawnPoints();
	LoadSpawnPoints();
}

//function that prints player cords and angle; uncomment function call in _rank to enable
CollectSpawnCords()
{
	SetDvar("scr_zmod_intermission_time", "300");
	
	while(1)
	{
		iPrintLn("Coords: " + self getOrigin() + " Angles: " + self GetPlayerAngles());
		wait 1.5;
	}
}

//creates all spawnpoints that are defined here
LoadSpawnPoints()
{	
	switch(getDvar("mapname"))
	{
		case "mp_rust":
			
			SetSpawnPoint("allies", 700, 1400, 280, -90);
			SetSpawnPoint("allies", 700, 1350, 280, -90);
			SetSpawnPoint("allies", 650, 1410, 280, -90);
			SetSpawnPoint("allies", 620, 1250, 280, -90);
			SetSpawnPoint("allies", 580, 1220, 280, -90);
			SetSpawnPoint("allies", 540, 1300, 280, -90);
			SetSpawnPoint("allies", 560, 1240, 280, -90);
			

			SetSpawnPoint("axis", -254, 1760, -236, 0);
			SetSpawnPoint("axis", 1130, 1762, -228, 180);
			SetSpawnPoint("axis", 1470, 1360, -236, -90);
			SetSpawnPoint("axis", 1400, -160, -228, 180);
			SetSpawnPoint("axis", 570, -20, -217, -90);
			SetSpawnPoint("axis", -260, -70, -234, -32);
			SetSpawnPoint("axis", -420, 940, -223, -90);
			
			break; 
		
		default:
			break;
	}
}