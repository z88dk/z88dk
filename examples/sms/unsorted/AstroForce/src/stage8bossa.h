void InitStage8BossA(enemy *en)
{
	// Stop scroll
	disablescroll=1;
}
			
unsigned char UpdateStage8BossA(enemy *en)
{
	if((en->enemyframe>16)&&(en->enemyframe<212))
	{
		if(en->enemyframe%8==0)
			InitEnemy(8+((myRand()%2)*240),24+myRand()%128,STAGE8LATERAL);
	}
	// Stop 3D scroll
	else if(en->enemyframe==16)
		stage8phase=1;
	
	// Stop 3D scroll
	else if(en->enemyframe==240)
		stage8phase=2;
	else if(en->enemyframe==255)
	{
		// Unstop scroll
		disablescroll=0;
		
		// The frames
		stageframe=0;
		
		// Exit
		return 0;
	}
	
	// Return live
	return 1;
}
