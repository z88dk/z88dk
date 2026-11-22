void DoEnemyWait(enemy *en, unsigned char nxt)
{
	if(en->enemyframe>=30)
	{
		en->enemyparama=nxt;
		en->enemyframe=0;
	}
}

void DoStage4EndBossSinusMovementVert(enemy *en)
{
	if(en->enemyparamb==0)
	{
		en->enemyposy+=3;
		if(en->enemyposy>=128)en->enemyparamb=1;
	}
	else
	{
		en->enemyposy-=3;
		if(en->enemyposy<=30)en->enemyparamb=0;
	}
}

void UpdateStage4EndBoss1(enemy *en)
{
	DoSkullSinusMovement(en,3,(en->enemytype==STAGE4ENDBOSS?0:24));
	
	// Shoot laser
	if(en->enemyframe%38==0)
		InitEnemyshootLaser(en->enemyposx+(en->enemytype==STAGE4ENDBOSS?0:16),en->enemyposy+40);
	else 
		// Shoot?
		TestEnemyShootComplex(en,24,8,48);	
		
	// Movement
	if(en->enemyframe==165)
	{
		en->enemyparama++;
		en->enemyframe=0;
	}
}

void UpdateStage4EndBoss2(enemy *en)
{
	DoEnemyWait(en,3);
}

void UpdateStage4EndBoss3(enemy *en)
{
	// Avoid die here
	if(en->enemyenergy<10)en->enemyenergy=10;

	// Move
	if(en->enemytype==STAGE4ENDBOSS)en->enemyposx-=2;else en->enemyposx+=2;
	if(en->enemyframe>=45)
	{
		en->enemyparama++;
		en->enemyframe=0;
	}
}

void UpdateStage4EndBoss4(enemy *en)
{
	// Avoid die here
	if(en->enemyenergy<10)en->enemyenergy=10;
	
	// Do vertical movement
	DoStage4EndBossSinusMovementVert(en);

	// Enemy
	if(en->enemyframe%36==12)
		InitEnemy(en->enemyposx+(en->enemytype==STAGE4ENDBOSS?24:0),en->enemyposy+(myRand()%40),STAGE4ENDBOSSB);
	else 
		// Shoot?
		TestEnemyShootComplex(en,28,12,16);

	// Movement
	if(en->enemyframe==135)
	{
		en->enemyparama++;
		en->enemyframe=0;
	}
}

void UpdateStage4EndBoss5(enemy *en)
{
	// Avoid die here
	if(en->enemyenergy<10)en->enemyenergy=10;
	
	// Waiting
	DoEnemyWait(en,6);
}

void UpdateStage4EndBoss6(enemy *en)
{
	// Avoid die here
	if(en->enemyenergy<10)en->enemyenergy=10;

	if(en->enemytype==STAGE4ENDBOSS)en->enemyposx+=2;else en->enemyposx-=2;
	if(en->enemyframe>=45)
	{
		en->enemyparama++;
		en->enemyframe=0;
	}
}

void UpdateStage4EndBoss7(enemy *en)
{
	DoEnemyWait(en,1);
}

unsigned char UpdateStage4EndBoss(enemy *en)
{
	// Draw
	DrawSpriteArray(en->enemytype==STAGE4ENDBOSS?STAGE4ENDBOSSBASE:STAGE4ENDBOSSBASEC,en->enemyposx,en->enemyposy,24,48);
	
	// Call custom function
	//changeBank(FIXEDBANKSLOT);
	(*(updatestage4endbossfunctions[en->enemyparama]))(en);

	// Return
	return 1;
}

