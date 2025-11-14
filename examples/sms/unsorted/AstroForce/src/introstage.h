void InitIntroScroll()
{
	introstageposx=0;
	introstagevelx=0;
}

void setIntroStageGraphics()
{
	// Load palette
	LoadBGPalette(logopalette_bin,logopalette_bin_bank);
	
	// Init script
	InitScripts();
	
	// Init enemies
	InitEnemies();
	
	// Init explosions
	InitExplosions();
	
	// Labels
	InitTimeredLabels();
	
	// Scroll
	SMS_setBGScrollY(192);
}

void InitIntroStage(unsigned char intronum)
{
	// General init
	InitStage();

	// Lo volvemos a apagar
	SMS_displayOff();

	// Too big here
	setIntroStageGraphics();

	// Too big here
	switch(intronum)
	{
		case 1:InitIntro1Stage();break;
		case 2:InitIntro2Stage();break;
		case 3:InitFinishStage();break;
		case 4:InitIntro3Stage();break;
		case 5:InitIntro4Stage();break;
	}
	
	// Lo volvemos a encender
	SMS_displayOn();

	// Scroller position
	InitIntroScroll();

	// Bucle
	while(1)
	{
		// The stage
		UpdateStage();
		
		// Timered labels
		UpdateTimeredLabels();

		// Script
		if((stageframe%8)==0)
			UpdateScripts();
		
		// Update stage, explosions, enemies
		if(stageframe2mod==0)
		{
			UpdateExplosions();
			UpdateEnemies();
		}
		
		// Only for stage 2 
		if(intronum==2)DoIntro2Scroll();
		
		// Play?
		if((keystatus&PORT_A_KEY_1)||(!PSGGetStatus()))
			return;
		
		// Update psg
		UpdatePSG();
	}
}


