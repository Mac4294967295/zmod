#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_shop_menu;

CreatePlayerHUD()
{
	//Shop Menu Elem
	b = -65;
	s = 15;
	i = 0;
	a = 0.85;

	self.scrollleft = NewClientHudElem( self );
	self.scrollleft.alignX = "center";
	self.scrollleft.alignY = "bottom";
	self.scrollleft.horzAlign = "center";
	self.scrollleft.vertAlign = "bottom";
	self.scrollleft.x = -230;
	self.scrollleft.y = -30;
	self.scrollleft.fontScale = 1;
	self.scrollleft.font = "hudbig";
	self.scrollleft.alpha = a;
	self.scrollleft.glow = 1;
	self.scrollleft.glowColor = ( 0, 0, 1 );
	self.scrollleft.glowAlpha = 1;
	self.scrollleft.color = ( 1.0, 1.0, 1.0 );

	self.scrollright = NewClientHudElem( self );
	self.scrollright.alignX = "center";
	self.scrollright.alignY = "bottom";
	self.scrollright.horzAlign = "center";
	self.scrollright.vertAlign = "bottom";
	self.scrollright.fontScale = 1.15;
	self.scrollright.x = 230;
	self.scrollright.y = -30;
	self.scrollright.fontScale = 1;
	self.scrollright.font = "hudbig";
	self.scrollright.alpha = a;
	self.scrollright.glow = 1;
	self.scrollright.glowColor = ( 0, 0, 1 );
	self.scrollright.glowAlpha = 1;
	self.scrollright.color = ( 1.0, 1.0, 1.0 );

	self.menutext = NewClientHudElem( self );
	self.menutext.alignX = "center";
	self.menutext.alignY = "bottom";
	self.menutext.horzAlign = "center";
	self.menutext.vertAlign = "bottom";
	self.menutext.y = b + (s * i);
	self.menutext.foreground = true;
	self.menutext.fontScale = 1.15;
	self.menutext.font = "objective";
	self.menutext.alpha = a;
	self.menutext.glow = 1;
	self.menutext.glowColor = ( 0.2, 0.2, 1 );
	self.menutext.glowAlpha = 1;
	self.menutext.color = ( 1.0, 1.0, 1.0 );
	i++;

	self.option1 = NewClientHudElem( self );
	self.option1.alignX = "center";
	self.option1.alignY = "bottom";
	self.option1.horzAlign = "center";
	self.option1.vertAlign = "bottom";
	self.option1.y = b + (s * i);
	self.option1.foreground = true;
	self.option1.fontScale = 1.15;
	self.option1.font = "objective";
	self.option1.alpha = a;
	self.option1.glow = 1;
	self.option1.glowColor = ( 0, 0, 1 );
	self.option1.glowAlpha = 1;
	self.option1.color = ( 1.0, 1.0, 1.0 );
	i++;

	self.option2 = NewClientHudElem( self );
	self.option2.alignX = "center";
	self.option2.alignY = "bottom";
	self.option2.horzAlign = "center";
	self.option2.vertAlign = "bottom";
	self.option2.y = b + (s * i);
	self.option2.foreground = true;
	self.option2.fontScale = 1.15;
	self.option2.font = "objective";
	self.option2.alpha = a;
	self.option2.glow = 1;
	self.option2.glowColor = ( 0, 0, 1 );
	self.option2.glowAlpha = 1;
	self.option2.color = ( 1.0, 1.0, 1.0 );
	i++;

	self.option3 = NewClientHudElem( self );
	self.option3.alignX = "center";
	self.option3.alignY = "bottom";
	self.option3.horzAlign = "center";
	self.option3.vertAlign = "bottom";
	self.option3.y = b + (s * i);
	self.option3.foreground = true;
	self.option3.fontScale = 1.15;
	self.option3.font = "objective";
	self.option3.alpha = a;
	self.option3.glow = 1;
	self.option3.glowColor = ( 0, 0, 1 );
	self.option3.glowAlpha = 1;
	self.option3.color = ( 1.0, 1.0, 1.0 ); 
  
  
	//Health Elem
	self.curhealth = 0;
	self.healthtext = NewClientHudElem( self );
	self.healthtext.alignX = "right";
	self.healthtext.alignY = "top";
	self.healthtext.horzAlign = "right";
	self.healthtext.vertAlign = "top";
	self.healthtext.y = -25;
	self.healthtext.x = 48;
	self.healthtext.foreground = true;
	self.healthtext.fontScale = 0.75;
	self.healthtext.font = "hudbig";
	self.healthtext.alpha = 1;
	self.healthtext.glow = 1;
	self.healthtext.glowColor = ( 2.55, 0, 0 );
	self.healthtext.glowAlpha = 1;
	self.healthtext.color = ( 1.0, 1.0, 1.0 );

	self.healthlabel = NewClientHudElem( self );
	self.healthlabel.alignX = "right";
	self.healthlabel.alignY = "top";
	self.healthlabel.horzAlign = "right";
	self.healthlabel.vertAlign = "top";
	self.healthlabel.y = -25;
	self.healthlabel.x = -5;
	self.healthlabel.foreground = true;
	self.healthlabel.fontScale = 0.75;
	self.healthlabel.font = "hudbig";
	self.healthlabel.alpha = 1;
	self.healthlabel.glow = 1;
	self.healthlabel.glowColor = ( 2.55, 0, 0 );
	self.healthlabel.glowAlpha = 1;
	self.healthlabel.color = ( 1.0, 1.0, 1.0 );

	self.healthlabel textPulseInit();
	self.healthtext textPulseInit();
	
	
	//Cash Elem
	self.cashlabel = NewClientHudElem( self );

	self.cashlabel.alignX = "right";
	self.cashlabel.alignY = "top";
	self.cashlabel.horzAlign = "right";
	self.cashlabel.vertAlign = "top";
	self.cashlabel.foreground = true;
	self.cashlabel.y = -10;
	self.cashlabel.x = -5;
	self.cashlabel.fontScale = 0.75;
	self.cashlabel.font = "hudbig";
	self.cashlabel.alpha = 1;
	self.cashlabel.glow = 1;
	self.cashlabel.glowAlpha = 1;
	self.cashlabel.color = ( 1.0, 1.0, 1.0 );

	self.cash = NewClientHudElem( self );
	self.cash.alignX = "right";
	self.cash.alignY = "top";
	self.cash.horzAlign = "right";
	self.cash.vertAlign = "top";
	self.cash.foreground = true;
	self.cash.y = -10;
	self.cash.x = 48;
	self.cash.fontScale = 0.75;
	self.cash.font = "hudbig";
	self.cash.alpha = 1;
	self.cash.glow = 1;
	self.cash.glowAlpha = 1;
	self.cash.color = ( 1.0, 1.0, 1.0 );

	self.cash textPulseInit();
	self.cashlabel textPulseInit();	
	
	
	//Lives Elem
	self.lifetext = NewClientHudElem( self );
	self.lifetext.alignX = "right";
	self.lifetext.alignY = "top";
	self.lifetext.horzAlign = "right";
	self.lifetext.vertAlign = "top";
	self.lifetext.y = 5;
	self.lifetext.x = 48;
	self.lifetext.foreground = true;
	self.lifetext.fontScale = 0.75;
	self.lifetext.font = "hudbig";
	self.lifetext.alpha = 1;
	self.lifetext.glow = 1;
	self.lifetext.glowColor = ( 0.45, 0.45, 1 );
	self.lifetext.glowAlpha = 1;
	self.lifetext.color = ( 1.0, 1.0, 1.0 );

	self.lifelabel = NewClientHudElem( self );
	self.lifelabel.alignX = "right";
	self.lifelabel.alignY = "top";
	self.lifelabel.horzAlign = "right";
	self.lifelabel.vertAlign = "top";
	self.lifelabel.y = 5;
	self.lifelabel.x = -5;
	self.lifelabel.foreground = true;
	self.lifelabel.fontScale = 0.75;
	self.lifelabel.font = "hudbig";
	self.lifelabel.alpha = 1;
	self.lifelabel.glow = 1;
	self.lifelabel.glowColor = ( 0.45, 0.45, 1 );
	self.lifelabel.glowAlpha = 1;
	self.lifelabel.color = ( 1.0, 1.0, 1.0 );

	self.lifetext textPulseInit();
	self.lifelabel textPulseInit();	
	
}

CreateServerHUD()
{
	level.infotext = NewHudElem();
	level.infotext.alignX = "center";
	level.infotext.alignY = "bottom";
	level.infotext.horzAlign = "center";
	level.infotext.vertAlign = "bottom";
	level.infotext.y = 25;
	level.infotext.foreground = true;
	level.infotext.fontScale = 1;
	level.infotext.font = "objective";
	level.infotext.alpha = 1;
	level.infotext.glow = 0;
	level.infotext.glowColor = ( 0, 0, 0 );
	level.infotext.glowAlpha = 1;
	level.infotext.color = ( 1.0, 1.0, 1.0 );
}

textPulseInit()
{
	self.baseFontScale = self.fontScale;
}

doTextPulse(type, scale)
{
	self thread textPulseThread(type, scale);
}

textPulseThread(type, scale)
{
	self notify("textpulse"+type);
	self endon("death");

	self ChangeFontScaleOverTime(0.05);
	if (isDefined(scale))
	self.fontScale *= scale;
	else
	self.fontScale *= 1.5;
	wait 0.1;
	self ChangeFontScaleOverTime(0.1);
	self.fontScale = self.baseFontScale;
}

doHealth()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill("HEALTH");		
		self.healthlabel setText( "Max HP: " );
		self.healthtext setText( self.maxhealth );
		//self.healthtext setValue(self.maxhealth);
		self.healthtext doTextPulse();
	}
}

doCash()
{
	self endon("disconnect");
	self thread monitorGamestate();
  
	while(1)
	{
		self waittill("CASH");
		
		//level waittill_any( "joined_team", "player_spawned", "changed_kit" );
		if( isAlive( self ) )
		{
			if (level.gameState != "intermission")
			{
				self.cashlabel.glowColor = ( 0, 1, 0 );
				self.cash.glowColor = ( 0, 1, 0 );
				self.cashlabel setText("Cash: ");
				self.cash setText( self.bounty );
			}
			else
			{
				self.cashlabel.glowColor = ( 0, 0, 1 );
				self.cash.glowColor = ( 0, 0, 1 );
				self.cashlabel setText("Credits: ");
				self.cash setText( self.credits );
			}
		}
	}
}

monitorGamestate()
{
	self endon("disconnect");
	
	while(1)
	{
		level waittill ( "gamestatechange" );
		
		if( level.gameState == "playing" )
			self notify( "CASH" );
	}
}

doLives()
{
	self endon("disconnect");
  	
	while(1)
	{
		self waittill("LIVES"); 
		self.lifelabel setText( "Lives: " );
		self.lifetext setText( self getCItemVal("life", "in_use") );
		//self.lifetext setValue(self getCItemVal("life", "in_use"));
	}
}

justScorePopup( text )
{
	glowAlpha = (1, 1, 1);
	hudColor = (1,1,0.5);
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	self notify( "scorePopup" );
	self.hud_scorePopup.color = hudColor;
	self.hud_scorePopup.glowColor = hudColor;
	self.hud_scorePopup.glowAlpha = glowAlpha;
	self.hud_scorePopup setText(text);
	self.hud_scorePopup.alpha = 0.85;
	self.hud_scorePopup thread fontPulseNew( self );
}
/*
scorePopup( amount, bonus, hudColor, glowAlpha )
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	if ( amount == 0 )
	{
		return;
	}
	self notify( "scorePopup" );
	self endon( "scorePopup" );
	self.xpUpdateTotal += amount;
	self.bonusUpdateTotal += bonus;
	wait ( 0.05 );
	increment = max( int( self.bonusUpdateTotal / 20 ), 1 );
	if ( self.bonusUpdateTotal )
	{
		while ( self.bonusUpdateTotal > 0 )
		{
			self.xpUpdateTotal += min( self.bonusUpdateTotal, increment );
			self.bonusUpdateTotal -= min( self.bonusUpdateTotal, increment );
			//self.hud_scorePopup setValue( self.xpUpdateTotal );
			wait ( 0.05 );
		}
	}
	else
		{
			wait ( 1.0 );
		}
	self.xpUpdateTotal = 0;
}
*/
fontPulseNew(player)
{
	self notify ( "fontPulse" );
	self endon ( "fontPulse" );
	self endon( "death" );

	player endon("disconnect");
	player endon("joined_team");
	player endon("joined_spectators");

	self ChangeFontScaleOverTime( self.inFrames * 0.05 );
	self.fontScale = self.maxFontScale;
	wait (self.inFrames * 0.05);

	self ChangeFontScaleOverTime( self.outFrames * 0.05 );
	self.fontScale = self.baseFontScale;
	wait 0.3;

	self fadeOverTime( 0.75 );
	self.alpha = 0;
}
