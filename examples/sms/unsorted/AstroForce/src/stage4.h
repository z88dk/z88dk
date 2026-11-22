void UpdateStage4()
{
	unsigned char p;

	if(stage4playrays==1)
	{
		// Get frame
		p=min((stageframe>>3)%48,15);
	
		// Bank
		//changeBank(FIXEDBANKSLOT);
		
		// Storm effect
		SMS_setBGPaletteColor (12,stage4_stormpalette[p]);
	
		// Storm sound
		if(stage4_stormpalette[p]==0x3f)
			PlaySound(ray_psg,1);
	}
	else
	{
		// Sea palette
		SMS_setBGPaletteColor(4,stage4_seapalette[(stageframe>>4)%4]);
	}
}

// Pantalla de juego
void InitStage4()
{
	// Load tiles
	LoadTiles(stage4tiles_psgcompr,stage4tiles_psgcompr_bank);
	

	// Sprites
	InitStageSprites(stage4spriteslist,10);
	
	// Scroller
	AddScrollers(stage4_scrollers,stage4_scrollers_num);
	
	// Scripter
	InitScript(stage4script,0);
	
	// Rays
	stage4playrays=1;
}	

