void InitStage3()
{
	unsigned char a;
	
	// Load tiles
	LoadTiles(stage3tiles_psgcompr,stage3tiles_psgcompr_bank);

	// Sprites
	InitStageSprites(stage3spriteslist,12);
		
	// Scripter
	InitScript(stage3script,0);
	
	// Map static enemies
	SetStaticEnemies(stage3_statics,stage3_statics_bank);
	
	// Scroller
	AddScrollers(stage3_scrollers,stage3_scrollers_num);
	
	// Stars
	LoadSprite(introstar_psgcompr, STAGE3STARBASE,introstar_psgcompr_bank);	
	for(a=0;a<MAXSTAGE3STARS;a++)
		InitStage3Star(&stage3stars[a],(myRand()%3)+2);
}

void UpdateStage3()
{
	unsigned char a;
	unsigned int sf;
	
	// The bank
	changeBank(spaceanimtiles_bin_bank);
	
	// Double scroll
	sf=((stageframe>>2)%(7*8))<<2;
	
	// Soltamos las tiles
	UNSAFE_SMS_VRAMmemcpy64(32,spaceanimtiles_bin+sf);
	UNSAFE_SMS_VRAMmemcpy64(32+64,spaceanimtiles_bin+sf+64);
	UNSAFE_SMS_VRAMmemcpy64(32+128,spaceanimtiles_bin+sf+128);
	UNSAFE_SMS_VRAMmemcpy32(32+192,spaceanimtiles_bin+sf+192);
	
	// Stars
	for(a=0;a<MAXSTAGE3STARS;a++)
		UpdateStage3Star(&stage3stars[a]);
}

