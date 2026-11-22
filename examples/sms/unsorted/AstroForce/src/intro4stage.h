void InitIntro4Stage()
{
	// Cargamos los graficos a la pantalla
	LoadGraphics(introstage3tiles_psgcompr,introstage3tilemap_bin,introstage3tilemap_bin_size,introstage3tiles_psgcompr_bank);

	// Music
	PlayMusic(silence_psg,silence_psg_bank,0);
	
	// Scripter
	InitScript(intro4script,0);
}