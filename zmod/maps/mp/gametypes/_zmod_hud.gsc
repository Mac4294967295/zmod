#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_shop_menu;

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
  self endon("death");
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
  self.healthlabel setText("Max HP: ");

  self.healthlabel textPulseInit();
  self.healthtext textPulseInit();

  while(1)
  {
    self.healthtext setValue(self.maxhealth);
    self.healthtext doTextPulse();
    self waittill("HEALTH");
  }
}

doCash()
{
  self endon("disconnect");
  self endon("death");
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
  self.cashlabel setText("Cash: ");

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

  while(1)
  {
    if (level.showcreditshop == false)
    {
      self.cashlabel.glowColor = ( 0, 1, 0 );
      self.cash.glowColor = ( 0, 1, 0 );
      self.cashlabel setText("Cash: ");
      self.cash setValue(self.bounty);
    }
    else
    {
      self.cashlabel.glowColor = ( 0, 0, 1 );
      self.cash.glowColor = ( 0, 0, 1 );
      self.cashlabel setText("Credits: ");
      self.cash setValue(self.credits);
    }
    self waittill("CASH");
  }
}

doLives()
{
  self endon("disconnect");
  self endon("death");
  curlives = -1;
  wait 0.2;
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
  self.lifelabel setText("Lives: ");

  self.lifetext textPulseInit();
  self.lifelabel textPulseInit();

  while(1)
  {
    self.lifetext setValue(self getCItemVal("life", "in_use"));
    self waittill("LIVES");
  }
}
