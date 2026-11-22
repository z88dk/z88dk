void UpdateStage8()
{
	unsigned int sf;

	// The BANK!!!
	changeBank(stage8animtilescloudsmov_bin_bank);
	
	if((stage8phase==0)||(stage8phase==2))
	{
		// Clouds
		sf=((16-((stageframe<<1)%16))<<2);
		UNSAFE_SMS_VRAMmemcpy64(256,stage8animtilescloudsmov_bin+sf);
		UNSAFE_SMS_VRAMmemcpy64(320,stage8animtilescloudsmov_bin+sf+128);
	}
	
	else if(stage8phase==1)
	{
		// RSG wall
		sf=((stageframe>>1)%8)*(7*32);
		UNSAFE_SMS_VRAMmemcpy64(0,stage8animtilesamov_bin+sf);
		UNSAFE_SMS_VRAMmemcpy64(64,stage8animtilesamov_bin+sf+64);
		UNSAFE_SMS_VRAMmemcpy64(128,stage8animtilesamov_bin+sf+128);
		UNSAFE_SMS_VRAMmemcpy32(192,stage8animtilesamov_bin+sf+192);
	}

	else if(stage8phase==3)
	{
	// RSG wall
		sf=((stageframe>>1)%8)*(7*32);
		UNSAFE_SMS_VRAMmemcpy64(384,stage8animtilesbmov_bin+sf);
		UNSAFE_SMS_VRAMmemcpy64(384+64,stage8animtilesbmov_bin+sf+64);
		UNSAFE_SMS_VRAMmemcpy32(384+128,stage8animtilesbmov_bin+sf+128);
	}		
	
	// Sea palette
	changeBank(FIXEDBANKSLOT);
	SMS_setBGPaletteColor(15,stage8animpalette[(stageframe>>2)%14]);
}

// Pantalla de juego
void InitStage8()
{
	// Load tiles
	LoadTiles(stage8tiles_psgcompr,stage8tiles_psgcompr_bank);
	
	// Sprites
	InitStageSprites(stage8spriteslist,7);
	
	// Map static enemies
	SetStaticEnemies(stage8_statics,stage8_statics_bank);
	
	// Scroller
	AddScrollers(stage8_scrollers,stage8_scrollers_num);
	
	// The phase
	stage8phase=0;
}

