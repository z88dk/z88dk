void DoCommonBossAppearingFunction(enemy *en)
{
	en->enemyposy++;
	if(en->enemyposy>=30)
	{
		en->enemyparama=1;
		en->enemyframe=0;
	}
}

void UpdateStage4MiddleBoss1(enemy *en)
{
	signed int p;
	unsigned char c;

	p=en->enemyframe;
	p=sinus(p<<1);
	en->enemyposx=108+p*3/4;
	if(en->enemyframe==255)
	{
		en->enemyparama=2;
		en->enemyframe=0;
		en->enemyparamb=8;
	}
	c=en->enemyframe%16;
	if(c==0)
		InitEnemyshoot(en->enemyposx+32,en->enemyposy+32,1);
	if(c==8)
		InitEnemyshoot(en->enemyposx,en->enemyposy+32,1);
}

void UpdateStage4MiddleBoss2(enemy *en)
{
	if(en->enemyframe>=20)
		en->enemyparama++;
}

void UpdateStage4MiddleBoss3(enemy *en)
{
	if(playerx+16<en->enemyposx+24)en->enemyposx-=4;
	else if(playerx>en->enemyposx+16)en->enemyposx+=4;
	else
	{
		InitEnemyshootLaser(en->enemyposx+16,en->enemyposy+32);
		en->enemyparamb--;
		if(en->enemyparamb==0)
			en->enemyparama=4;
		else
		{
			en->enemyparama=2;
			en->enemyframe=0;
		}
	}
}

void UpdateStage4MiddleBoss4(enemy *en)
{
	if(en->enemyposx<107)en->enemyposx+=3;
	else if(en->enemyposx>109)en->enemyposx-=3;
	else 
	{
		en->enemyparama=1;
		en->enemyframe=0;
	}
}

void FinishStage4MiddleBoss()
{
	// Metemos un enemigo que retrase esto
	InitEnemy(0,0,STAGE4OBJECT);
}

unsigned char UpdateStage4MiddleBoss(enemy *en)
{
	// Draw
	DrawSpriteArray(STAGE4MIDDLEBOSSBASE,en->enemyposx,en->enemyposy,40,40);

	// Call custom function
	//changeBank(FIXEDBANKSLOT);
	(*(updatestage4middlebossfunctions[en->enemyparama]))(en);
		
	// Exit
	return 1;
}
