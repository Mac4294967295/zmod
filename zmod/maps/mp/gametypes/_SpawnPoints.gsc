dogamespawn(maps)
{
    x = randomIntRange(-75, 75);
    y = randomIntRange(-75, 75);
	z = 45;
	switch(maps)
	{
    case "mp_afghan":
		self.neworiginspawn = (2571+x,21+y,120+z);
		self.newangles = (0, -3, 0);
		break;
		
	case "mp_derail":
		self.neworiginspawn = (-62+x,585+y, 106+z);
		self.newangles = (0, 90, 0);
	    break;
		
	case "mp_estate":
	    self.neworiginspawn = (-284+x,995+y, 190+z);
		self.newangles = (0, -13, 0);
		break;
		
	case "mp_checkpoint":
		self.neworiginspawn = (2517+x,-2429+y, 25+z);
		self.newangles = (0, 0, 0);
	    break;
		
	case "mp_quarry":
		self.neworiginspawn = (-4805+x,1039+y, -191+z);
		self.newangles = (0, -90, 0);
	    break;
		
	case "mp_nightshift":
		self.neworiginspawn = (-363+x,-269+y, 173+z);
		self.newangles = (0, 179, 0);
	    break;
		
	case "mp_subbase":
		self.neworiginspawn = (-1355+x,-1727+y, 0+z);
		self.newangles = (0, 50, 0);
	    break;
		
	case "mp_terminal":
		self.neworiginspawn = (2302+x,6115+y, 192+z);
		self.newangles = (0, 176, 0);
	    break;
		
	case "mp_underpass":
		self.neworiginspawn = (98+x,1528+y, 521+z);
		self.newangles = (0, 84, 0);
	    break;
		
	case "mp_invasion":
		self.neworiginspawn = (1693+x,-1918+y, 288+z);
		self.newangles = (0, -132, 0);
	    break;
	}
	wait 0.3;
	self setOrigin(self.neworiginspawn);
	self setPlayerAngles(self.newangles);
}




