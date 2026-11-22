void InitIntro1Stage()
{
	// Cargamos los graficos a la pantalla
	LoadGraphics(introstage1tiles_psgcompr,introstage1tilemap_bin,introstage1tilemap_bin_size,introstage1tiles_psgcompr_bank);
	
	// El sprite de los ovnis
	LoadSprite(introovni_psgcompr, INTROOVNIBASE,introovni_psgcompr_bank);
	
	// Rom bank
	PlayMusic(intro1_psg,intro1_psg_bank,0);
	
	// Scripter
	InitScript(intro1script,intro1labels);
}