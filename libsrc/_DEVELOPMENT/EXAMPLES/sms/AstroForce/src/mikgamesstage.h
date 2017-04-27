void InitMikGamesStage()
{
	// General init
	InitStage();

	// Lo volvemos a apagar
	SMS_displayOff();

	// Load palette
	LoadBGPalette(logopalette_bin,logopalette_bin_bank);
	
	// Cargamos los graficos a la pantalla
	LoadGraphics(mikgamestiles_psgcompr,mikgamestilemap_bin,mikgamestilemap_bin_size,mikgamestiles_psgcompr_bank);

	// Scroll
	SMS_setBGScrollY(16);
		
	// Lo volvemos a encender
	SMS_displayOn();

	// Bucle
	while(1)
	{
		// Update stage
		UpdateStage();

		// Scroll
		if(stageframe<30)
			SMS_setBGScrollY(16+(stageframe<<2));
		
		// Play?
		if(keystatus&PORT_A_KEY_1)
			return;
		
		// Done?
		if(stageframe>120)return;
		
		// Update psg
		UpdatePSG();
	}
}
