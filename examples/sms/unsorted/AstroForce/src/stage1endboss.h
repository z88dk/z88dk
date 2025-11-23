void DoStage1BossDirectionShoots(enemy *en)
{
	if(en->enemyframe%96==48)
		SpreadEnemyshootDirection(en->enemyposx+20,en->enemyposy+24,stage2endbossshootpatternx,stage2endbossshootpatterny,6);
}
			
void UpdateStage1EndBoss1(enemy *en)
{
	// Sinus movement
	DoSkullSinusMovement(en,2,0);
	
	// Do shooting
	if(en->enemyframe%96<24)
	{
		// Shoot?
		TestEnemyShootComplex(en,8,16,40);
	}
	else
	{
		DoStage1BossDirectionShoots(en);
		if(en->enemyframe%96==72)
		{
			InitEnemyshootLaser(en->enemyposx,en->enemyposy+36);
			InitEnemyshootLaser(en->enemyposx+32,en->enemyposy+36);
		}
	}
	
	// Ball
	if(en->enemyframe%24==16)
		InitEnemy(en->enemyposx+12,en->enemyposy+16,STAGE1MIDDLEBOSSC);
}

unsigned char UpdateStage1EndBoss(enemy *en)
{
	// Draw
	DrawSpriteArray(STAGE1ENDBOSSBASE,en->enemyposx,en->enemyposy,40,48);
	
	// Movement
	if(en->enemyparama==0)
		DoCommonBossAppearingFunction(en);
	else
		UpdateStage1EndBoss1(en);

	// Return
	return 1;
}

