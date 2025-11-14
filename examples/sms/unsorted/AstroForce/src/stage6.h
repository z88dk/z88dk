void InitStage6()
{
	// Load tiles
	LoadTiles(stage6tiles_psgcompr,stage6tiles_psgcompr_bank);

	// Sprites
	
	// ORIGINAL
	InitStageSprites(stage6spriteslist,3);
	
	//InitStageSprites(stage6spriteslist,2);

	// Scripter
	InitScript(stage6script,0);
	
	// Scroller
	AddScrollers(stage6_scrollers,stage6_scrollers_num);
	
	// Palette Fix
	SMS_setBGPaletteColor(9,0);
}

void UpdateStage6()
{
	unsigned char a;
	
	// Change bank
	changeBank(FIXEDBANKSLOT);
	
	// Palette effect
	a=(stageframe>>3)%8;
	SMS_setBGPaletteColor(2,stage6_fade_pink[a]);
	SMS_setBGPaletteColor(3,stage6_fade_pink[a]);
	SMS_setBGPaletteColor(13,stage6_fade_blue[a]);
	SMS_setBGPaletteColor(15,stage6_fade_blue[a]);
	SMS_setBGPaletteColor(14,stage6_fade_blue[a]);
}

