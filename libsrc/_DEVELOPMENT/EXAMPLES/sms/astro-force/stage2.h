unsigned char CheckCollisionStage2(unsigned char x,unsigned char y)
{
	unsigned char l=getTileAt(x,y);
	if((l==2)||(l==3))
		return 1;
	return 0;
}	

void UpdateStage2()
{
	// The bank	
	changeBank(firetiles_bin_bank);

	// Parallax
	UNSAFE_SMS_VRAMmemcpy64(0,firetiles_bin+(((stageframe>>2)%16)<<6));
}

// Pantalla de juego
void InitStage2()
{
	// Load tiles
	LoadTiles(stage2tiles_psgcompr,stage2tiles_psgcompr_bank);
	
	// Sprites
	InitStageSprites(stage2spriteslist,8);
	
	/*
	InitVulcanVulcanSprite();
	InitVulcanLaserSprite();
	InitVulcanLavaSprite();
	InitVulcanTankSprite();
	InitVulcanStationSprite();
	InitVulcanBirdSprite();
	InitStage2EndBossSprite();
	InitWarningSprite();
	*/
	
	// Map static enemies
	SetStaticEnemies(stage2_statics,stage2_statics_bank);
	
	// Scroller
	AddScrollers(stage2_scrollers,stage2_scrollers_num);
}

