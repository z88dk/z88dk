void InitFinishStage()
{
	// Cargamos los graficos a la pantalla
	LoadGraphics(endingstagetiles_psgcompr,endingstagetilemap_bin,endingstagetilemap_bin_size,endingstagetiles_psgcompr_bank);

	// El sprite de la nave lateral
	LoadSprite(introsideplayer_psgcompr, INTROSIDEPLAYERBASE,introsideplayer_psgcompr_bank);

	// Estrellas
	LoadSprite(introstar_psgcompr, INTROSTARBASE,introstar_psgcompr_bank);	

	// Rom bank
	PlayMusic(ending_psg,ending_psg_bank,0);
	
	// Scripter
	InitScript(finishscript,finishlabels);
	
	// To keep exit
	stagenum=10;
}