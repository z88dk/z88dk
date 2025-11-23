void UpdateStage5EndBoss0(enemy *en)
{
	en->enemyposy--;
	if(en->enemyposy<=128)
	{
		en->enemyparama=1;
		en->enemyparamb=0;
		en->enemyframe=0;
	}
}

void UpdateStage5EndBoss1(enemy *en)
{
	unsigned char a;
	
	if(en->enemyframe==250)
	{
		en->enemyparama=2;
		return;
	}

	// Skull movement!
	DoSkullSinusMovement(en,2,0);

	// Shooting
	if(en->enemyframe%80==64)
	{
		for(a=0;a<5;a++)
		{
			InitEnemy(en->enemyposx+(a*8),en->enemyposy+48,STAGE5MISSILE);
			enemies[numenemies-1].enemyparamb=a;
		}
		// Sound
		PlaySound(enemybomb_psg,1);
	}
}

void UpdateStage5EndBoss2(enemy *en)
{
	en->enemyposy--;
	if(en->enemyposy<=24)
	{
		en->enemyparama=3;
		en->enemyparamb=0;
		en->enemyframe=0;
	}
}

void UpdateStage5EndBoss3(enemy *en)
{
	if(en->enemyframe==250)
	{
		en->enemyparama=4;
		return;
	}

	// Skull movement!
	DoSkullSinusMovement(en,2,0);

	// Shooting
	if(en->enemyframe%16==4)
	{
		InitEnemyshoot(en->enemyposx,en->enemyposy+20,1);
		InitEnemyshoot(en->enemyposx+32,en->enemyposy+20,1);
	}
	
	// Laser
	if(en->enemyframe%32==0)
		InitEnemyshootLaser(en->enemyposx+16,en->enemyposy+56);
}

void UpdateStage5EndBoss4(enemy *en)
{
	en->enemyposy++;
	if(en->enemyposy>=128)
	{
		en->enemyparama=1;
		en->enemyparamb=0;
		en->enemyframe=0;
	}
}

unsigned char UpdateStage5EndBoss(enemy *en)
{
	// Draw
	DrawSpriteArray(STAGE5ENDBOSSBASE,en->enemyposx,en->enemyposy,40,56);

	// Call custom function
	//changeBank(FIXEDBANKSLOT);
	(*(updatestage5endbossfunctions[en->enemyparama]))(en);

	// Exit
	return 1;
}
