void InitGameoverStage()
{
	// General init
	InitStage();

	// Lo volvemos a apagar
	SMS_displayOff();

	// Load palette
	LoadBGPalette(logopalette_bin,logopalette_bin_bank);
	
	// Labels
	WriteText("GAME  OVER",11,12);
	WriteText("PRESS FIRE TO CONTINUE",5,14);
	
	// Lo volvemos a encender
	SMS_displayOn();

	// Rom bank
	PlayMusic(gameover_psg,gameover_psg_bank,0);
	
	// Bucle
	while(1)
	{
		// Update stage
		UpdateStage();

		// Play?
		if(keystatus&PORT_A_KEY_1)
		{
			// Init stage and players
			stagenum=laststagenum;
			numplayers=gamestock;
			
			// Exit
			return;
		}
		
		// Exit if done
		if(!PSGGetStatus())
		{
			// Set an stagenum to exit gameover_psg
			stagenum=10;
			
			// Fueri
			return;
		}
		
		// Update psg
		UpdatePSG();
	}
}