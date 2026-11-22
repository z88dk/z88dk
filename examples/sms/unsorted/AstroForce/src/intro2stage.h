void DoIntro2Scroll()
{
	// Scroll
	if((!stageframe2mod))
	{
		introstagevelx=stageframe>>3;
		if(introstagevelx>32)introstagevelx=32;
		introstageposx+=introstagevelx;
		UpdateScroll(-introstageposx>>2,-64);
	}
}

void InitIntro2Stage()
{
	// Cargamos los graficos a la pantalla
	LoadGraphics(introstage2tiles_psgcompr,introstage2tilemap_bin,introstage2tilemap_bin_size,introstage2tiles_psgcompr_bank);

	// El sprite de la nave lateral
	LoadSprite(introsideplayer_psgcompr, INTROSIDEPLAYERBASE,introsideplayer_psgcompr_bank);

	// Rom bank
	PlayMusic(intro2_psg,intro2_psg_bank,0);
	
	// Scripter
	InitScript(intro2script,0);
}