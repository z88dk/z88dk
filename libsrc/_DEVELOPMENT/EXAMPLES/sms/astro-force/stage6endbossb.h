void UpdateStage6EndBossB0(enemy *en)
{
	en->enemyposy--;
	if(en->enemyposy<=32)
	{
		en->enemyparama=1;
		en->enemyparamb=0;
		en->enemyframe=0;		
	}
}

void UpdateStage6EndBossB1(enemy *en)
{
	// Sinus movement
	DoSkullSinusMovement(en,3,0);
	
	// Launch bones
	LaunchSkullBoneC(en,0);
	
	// Shoot
	if(en->enemyframe%12==2)
		InitEnemyshoot(en->enemyposx+(myRand()%32),en->enemyposy+(myRand()%48),1);
}

void InitStage6EndBossB(enemy *en)
{
	LoadSprite(skullb_psgcompr,STAGE6ENDBOSSBASE,skullb_psgcompr_bank);
}

unsigned char UpdateStage6EndBossB(enemy *en)
{
	// DRaw skull
	DrawSpriteArray(STAGE6ENDBOSSBASE,en->enemyposx,en->enemyposy,40,56);

	// Update
	if(en->enemyparama==0)
		UpdateStage6EndBossB0(en);
	else
		UpdateStage6EndBossB1(en);
	
	// Return
	return 1;
}

