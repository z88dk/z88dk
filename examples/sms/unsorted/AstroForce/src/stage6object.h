unsigned char UpdateStage6Object(enemy *en)
{
	if(en->enemyframe>128)
	{
		// Pasamos al siguiente paso de scroll
		updatescrollact();
	
		// Music
		PlayMusic(escape_psg,escape_psg_bank,1);
		
		// Script
		InitScript(stage6scriptb,0);
		
		// Exit
		return 0;
	}
	else return 1;
}


