void CheckStage7PlayerMovement()
{
	unsigned int ny;
	unsigned char l,m;
	unsigned int nl;

	// The bank!!!
	changeBank(mapbank);
	
	
	// The collision
	ny=((mappositiony>>2)+playery)>>3;
	l=maplines[ny];
	nl=l;
	nl=(nl<<6)+((playerx>>3)<<1);
	l=maptiles[nl];
	m=maptiles[nl+1];
	
	if(l==12)
	{
		if(m==0)
			playerx--;
		if(m==2)
			playerx++;
	}
	
}

void UpdateStage7()
{
	unsigned int sf;
	
	// The bank	
	changeBank(stage7animtiles_bin_bank);

	// Center scroll
	sf=((stageframe%16)<<2);
	UNSAFE_SMS_VRAMmemcpy64(0,stage7animtilese_bin+sf);
	UNSAFE_SMS_VRAMmemcpy64(64,stage7animtilese_bin+sf+128);

	// Only if scroll
	if(disablescroll==0)
	{
		
		// Middle scroll
		sf=(((stageframe>>2)%16)<<2);
		UNSAFE_SMS_VRAMmemcpy64(256,stage7animtilesd_bin+sf);
		UNSAFE_SMS_VRAMmemcpy64(320,stage7animtilesd_bin+sf+128);

		
		// Far scroll
		sf=(((stageframe>>3)%16)<<2);
		UNSAFE_SMS_VRAMmemcpy64(128,stage7animtiles_bin+sf);
		UNSAFE_SMS_VRAMmemcpy64(192,stage7animtiles_bin+sf+128);
	}
	
	// Water falls
	UNSAFE_SMS_VRAMmemcpy32(384,stage7animtilesc_bin+(((stageframe>>1)%8)<<5));
	
	// Check for playerx movement
	if(stageframe%2==0)
		CheckStage7PlayerMovement();
	
}

// Pantalla de juego
void InitStage7()
{
	// Load tiles
	LoadTiles(stage7tiles_psgcompr,stage7tiles_psgcompr_bank);

	// Sprites
	InitStageSprites(stage7spriteslist,6);
	
	/*
	InitMonsterBlobSprite();
	InitMonsterHeadSprite(); 
	InitMonsterMissilSprite();
	InitStage7MiddleBossSprite();
	InitStage7EndBossSprite();
	InitWarningSprite();
	*/
	
	// Scroller
	AddScrollers(stage7_scrollers,stage7_scrollers_num);
	
	// Map static enemies
	SetStaticEnemies(stage7_statics,stage7_statics_bank);
	
	// Custom velocity in this stage
	playstageshootspeed-=1;
}

unsigned char CheckCollisionStage7(unsigned char x,unsigned char y)
{
	if(getTileAt(x,y)>29)return 1;
	return 0;
}
