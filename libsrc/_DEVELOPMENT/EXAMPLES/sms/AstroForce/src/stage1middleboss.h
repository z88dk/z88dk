void UpdateStage1MiddleBoss1(enemy *en)
{
	// Sinus movement
	DoSkullSinusMovement(en,2,0);
	
	// Do shooting
	DoStage1BossDirectionShoots(en);

	// Ball
	if(en->enemyframe%20==16)
		InitEnemy(en->enemyposx+12,en->enemyposy+24,STAGE1MIDDLEBOSSB);
}

void FinishStage1MiddleBoss()
{
	// Pasamos al siguiente paso de scroll
	updatescrollact();
}

unsigned char UpdateStage1MiddleBoss(enemy *en)
{
	// Draw
	DrawSpriteArray(STAGE1MIDDLEBOSSBASE,en->enemyposx,en->enemyposy,40,32);
	
	// Movement
	if(en->enemyparama==0)
		DoCommonBossAppearingFunction(en);
	else
		UpdateStage1MiddleBoss1(en);

	// Return
	return 1;
}
