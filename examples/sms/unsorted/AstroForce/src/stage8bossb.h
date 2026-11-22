void UpdateStage8BossB1(enemy *en)
{
	unsigned char a;
	
	// Have to change?
	if(en->enemyenergy<10)
	{
		en->enemyparama++;
		en->enemyenergy=150;		
		en->enemyframe=0;
	}

	// Draw
	DrawSpriteArray(STAGE8BOSSBBASE+(((stageframe>>2)%6)*20),en->enemyposx,en->enemyposy,32,40);

	// Shoot
	if(en->enemyframe%4==0)
	{
		a=(en->enemyframe%64)>>2;
		InitEnemyshootDirection(en->enemyposx+12, en->enemyposy+24, stage8bossbshootspeedx[a], stage8bossbshootspeedy[a]);
	}
}

void UpdateStage8BossB2(enemy *en)
{
	// Switch
	if(en->enemyframe>=64)
	{
		en->enemyparama++;
		en->enemyframe=0;
	}
	
	// Draw
	DrawSpriteArray(STAGE8BOSSBBASE+60,en->enemyposx,en->enemyposy,32,40);
}

void UpdateStage8BossB3(enemy *en)
{
	// Move
	DoSkullSinusMovement(en,2,0);

	// Draw
	DrawSpriteArray(STAGE8BOSSBBASE+(((stageframe>>2)%6)*20),en->enemyposx,en->enemyposy,32,40);

	// Launch enemies
	if(numenemies<3)
		if(en->enemyframe%32==24)
			InitEnemy(en->enemyposx+8,en->enemyposy+24,RSGTHING);

	// Shoot
	DoStage1BossDirectionShoots(en);
}

void InitStage8BossB(enemy *en)
{
	// Load sprite... a big trouble here
	LoadSprite(stage8bossb_psgcompr,STAGE8BOSSBBASE,stage8bossb_psgcompr_bank);
	
	// Stop scroll
	disablescroll=1;
	
	// Change stage 8 phase
	stage8phase=3;
}

unsigned char UpdateStage8BossB(enemy *en)
{
	if(en->enemyparama==0)
		DrawSpriteArray(STAGE8BOSSBBASE+60,en->enemyposx,en->enemyposy,32,40);
	
	// Call custom function
	//changeBank(FIXEDBANKSLOT);
	(*(updatestage8bossbfunctions[en->enemyparama]))(en);
	
	// Return
	return 1;
}
