unsigned char UpdateStage4Object(enemy *en)
{
	if(en->enemyframe>128)
	{
		// Pasamos al siguiente paso de scroll
		updatescrollact();
	
		// Ya no hay mas rayos
		stage4playrays=0;
		
		// Scripter
		InitScript(stage4scriptb,0);
		
		// Exit
		return 0;
	}
	else return 1;
}


