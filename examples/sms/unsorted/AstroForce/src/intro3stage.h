void InitIntro3Stage()
{
	// Warning sprite
	LoadSprite(warning_psgcompr,WARNINGBASE,warning_psgcompr_bank);

	// Load palette
	LoadBGPalette(personspalette_bin,personspalette_bin_bank);

	// Load tiles
	LoadTiles(persons_psgcompr,persons_psgcompr_bank);
	
	// Music
	PlayMusic(intro3_psg,intro3_psg_bank,0);
	
	// Scripter
	InitScript(intro3script,intro3labels);
}
