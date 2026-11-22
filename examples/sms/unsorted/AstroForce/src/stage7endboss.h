void InitStage7EndBossB(enemy *en)
{
	// Velocity only
	en->enemyparama=4;
	en->enemyparamb=4;
}

void InitStage7EndBoss(enemy *en)
{
	unsigned char a;
	
	// Init body
	InitStage7EndBossB(en);
	
	// Corps
	for(a=6;a>=1;a--)
		InitEnemy(en->enemyposx-(a*12),en->enemyposy-(a*12),STAGE7ENDBOSSB);
}

void DoWormMovement(enemy *en)
{
	// Squalls
	if(en->enemyposx>232)en->enemyparama=0;
	if(en->enemyposx<8)en->enemyparama=4;
	if((en->enemyposy>176)&&(en->enemyposy<192))en->enemyparamb=0;
	if(en->enemyposy<8)en->enemyparamb=4;

	// Movement
	en->enemyposx+=en->enemyparama-2;
	en->enemyposy+=en->enemyparamb-2;
}

unsigned char UpdateStage7EndBoss(enemy *en)
{
	// Worm Movement
	DoWormMovement(en);

	// Sprite
	DrawQuadSprite(en->enemyposx,en->enemyposy,STAGE7ENDBOSSBASE+(((stageframe>>3)%2)<<2));
		
	// Shoot?
	TestEnemyShootComplex(en,16,4,4);
	
	// Return
	return 1;
}

unsigned char UpdateStage7EndBossB(enemy *en)
{
	// This enemy does not die never
	if(en->enemyenergy<10)en->enemyenergy=10;

	// Do same movement
	DoWormMovement(en);

	// Sprite
	DrawQuadSprite(en->enemyposx,en->enemyposy,STAGE7ENDBOSSBASE+8);	
	
	// Return
	return 1;
}
