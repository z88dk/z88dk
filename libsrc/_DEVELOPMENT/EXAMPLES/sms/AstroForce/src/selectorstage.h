void UpdateSelectorMarks(unsigned char selected_stage)
{
	unsigned char a;
	unsigned char b;
	unsigned char c;
	unsigned char d=0;
	
	// My bank
	changeBank(FIXEDBANKSLOT);
	
	// Graphics
	for(a=0;a<5;a++)
	{
		// Selector
		c=(a*6)+1;
		for(b=0;b<4;b++)
		{
			SMS_setNextTileatXY(c+selectormarkx[b],selectormarky[b]);
			SMS_setTile(a==selected_stage?selectormarkt[b]:0);
		}

		// Base tiles
		d=selectorstatebasetiles[a];
		
		// Images
		for(b=0;b<4;b++)
		{
			SMS_setNextTileatXY(2+a*6,10+b);
			for(c=0;c<4;c++)
				SMS_setTile(d++);
			d+=4;
		}
	}
	
	// Name
	WriteText(selectornamestage[selected_stage],12,17);
}

void InitSelectorStage()
{
	unsigned char selected_stage=0;
	unsigned char keyfree=1;
	
	// General init
	InitStage();

	// Lo volvemos a apagar
	SMS_displayOff();

	// Load palette
	LoadBGPalette(selectorpalette_bin,selectorpalette_bin_bank);
	
	// Load tiles
	LoadTiles(selectortiles_psgcompr,selectortiles_psgcompr_bank);
	
	// Labels
	WriteText("SELECT INITIAL STAGE",6,6);
	
	// Lo volvemos a encender
	SMS_displayOn();

	// Rom bank
	PlayMusic(select_psg,select_psg_bank,1);
	
	// Bucle
	while(1)
	{
		// Update stage
		UpdateStage();

		// Selector marks
		UpdateSelectorMarks(selected_stage);
		
		// Selector left
		if(keystatus&PORT_A_KEY_LEFT)
		{
			if(keyfree==1)
				if(selected_stage>0)
					selected_stage--;
			keyfree=0;
		}

		// Selector right
		else if(keystatus&PORT_A_KEY_RIGHT)
		{
			if(keyfree==1)
				if(selected_stage<4)
					selected_stage++;
			keyfree=0;
		}
		// No key
		else keyfree=1;
		
		// Play?
		if(keystatus&PORT_A_KEY_1)
		{
			basestage=selected_stage;
			InitPlayerConstants();
			return;
		}
		
		// Update psg
		UpdatePSG();
	}
}