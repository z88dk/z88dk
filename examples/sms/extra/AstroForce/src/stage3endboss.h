void DoStage3EndBossCrossShooting(enemy *en)
{
	unsigned char a,b;

	// Random factor
	a=(myRand()%2);
	
	// Let's put lasers!
	for(b=0;b<4;b++)
	{
		InitEnemy(en->enemyposx+stage3enemylaserposx[a]-8,en->enemyposy+stage3enemylaserposy[a]-8,STAGE3LASERUP+a);
		a+=2;
	}
}

void UpdateStage3EndBoss2(enemy *en)
{
	DoEnemyWait(en,1+(en->enemyparama%4));
	if(en->enemyframe==20)DoStage3EndBossCrossShooting(en);
}

void UpdateStage3EndBoss1(enemy *en)
{
	// Do pattern movement
	if(en->enemytype==STAGE3ENDBOSS)
		DoAracPatternMovement(en,crossamovingx,crossamovingy,crossamovingt);
	else
		DoAracPatternMovement(en,crossbmovingx,crossbmovingy,crossbmovingt);		

	// Shoot?
	TestEnemyShootComplex(en,48,12,12);
}

unsigned char UpdateStage3EndBoss(enemy *en)
{
	// Draw
	DrawSpriteArray(STAGE3ENDBOSSBASE,en->enemyposx,en->enemyposy,32,32);

	// Fix
	en->enemyparama%=5;
	
	// Call custom function 
	//changeBank(FIXEDBANKSLOT); 
	(*(updatestage3endbossfunctions[en->enemyparama]))(en); 

	// Exit
	return 1;
}
