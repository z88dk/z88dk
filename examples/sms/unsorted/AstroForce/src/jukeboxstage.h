unsigned char jukeboxselectedline;
unsigned char jukeboxselectedsong;
unsigned char jukeboxcheckkey;

char UpdateJukeboxInfo()
{
	// My BANK!
	changeBank(FIXEDBANKSLOT);
	
	// Cursors
	SMS_addSprite(32,(8+(jukeboxselectedline<<1))<<3,CURSORSBASE);
	
	// Music Name
	WriteText((unsigned char *)jukebox_names[jukeboxselectedsong],16,14);
	
	// Level
	WriteText((unsigned char *)difficultlabels[gamelevel],16,10);
	
	// Stock
	WriteNumber(gamestock,2,15,12);

	// Action?
	if(jukeboxcheckkey==1)
	{
		// Reset
		jukeboxcheckkey=0;
		
		// Musica nombre
		if(jukeboxselectedline==3)
		{
			if(keystatus&PORT_A_KEY_LEFT)if(jukeboxselectedsong>0)jukeboxselectedsong--;
			if(keystatus&PORT_A_KEY_RIGHT)if(jukeboxselectedsong<20)jukeboxselectedsong++;
		}
		
		// Cursors
		if(keystatus&PORT_A_KEY_UP)if(jukeboxselectedline>1)(jukeboxselectedline)--;
		if(keystatus&PORT_A_KEY_DOWN)if(jukeboxselectedline<4)(jukeboxselectedline)++;

		// Pushed
		if(keystatus&PORT_A_KEY_1)
		{
			switch(jukeboxselectedline)
			{
				case 1:
					gamelevel=1-gamelevel;
				break;
				case 2:
					gamestock=1+(gamestock%6);
				break;
				case 3:
					PlayMusic((unsigned char *)jukebox_songs[jukeboxselectedsong],jukebox_banks[jukeboxselectedsong],jukebox_repeat[jukeboxselectedsong]);
				break;
				case 4: 
					return 0;
				break;
			}
		}
	}
	
	// Reset key status
	if(keystatus==0)jukeboxcheckkey=1;

	// Exit
	return 1;
}

void InitJukeboxStage()
{
	// Line
	jukeboxselectedline=1;
	
	// Set current song
	jukeboxselectedsong=0;

	// To avoid troubles with keys
	jukeboxcheckkey=0;
	
	// General init
	InitStage();

	// Lo volvemos a apagar
	SMS_displayOff();

	// Load palette
	LoadBGPalette(logopalette_bin,logopalette_bin_bank);
	
	// Cursors, sprites, blah blah blah...
	LoadSprite(cursors_psgcompr, CURSORSBASE,cursors_psgcompr_bank);
	
	// Lo volvemos a encender
	SMS_displayOn();

	// Los textos
	WriteText("GAME OPTIONS",10,6);
	WriteText("LEVEL",6,10);
	WriteText("STOCK",6,12);
	WriteText("MUSIC",6,14);
	WriteText("EXIT",6,16);

	// Bucle
	while(1)
	{
		// Update stage
		UpdateStage();

		// Update info
		if(UpdateJukeboxInfo()==0)return;
		
		// Update psg
		UpdatePSG();
	}
}