void UpdateSpaceStation1(enemy *en)
{
	if(en->enemyframe>=25)
		en->enemyparama++;
}

void UpdateSpaceStation2(enemy *en)
{
	if(playerx+16<en->enemyposx)en->enemyposx-=3;
	else if(playerx>en->enemyposx+24)en->enemyposx+=3;
	else
	{
		InitEnemyshootLaser(en->enemyposx,en->enemyposy+16);
		InitEnemyshootLaser(en->enemyposx+16,en->enemyposy+16);
		en->enemyframe=0;
		en->enemyparama--;
	}
}

void FinishSpaceStation()
{
	// Scripter
	InitScript(stage3scriptb,0);
}

	
unsigned char UpdateSpaceStation(enemy *en)
{
	unsigned char a;
	
	// Draw
	DrawSpriteArray(SPACESTATIONBASE,en->enemyposx,en->enemyposy,24,24);

	// Spread ships
	a=stageframe%80;
	if(a==1)
		InitEnemy(8,0,RECTSHIP);
	else 
	if(a==41)
		InitEnemy(232,0,RECTSHIP);

	// Spread asteroids
	a=stageframe%115;
	if(a==0)
		InitEnemy(0,0,SPACEASTEROIDBIG);
	else
	if(a==47)
		InitEnemy(0,0,SPACEASTEROIDMEDIUM);
	else
	if(a==95)
		InitEnemy(0,0,SPACEASTEROIDLITTLE);
		
	// Call custom function
	//changeBank(FIXEDBANKSLOT);
	(*(updatespacestationfunctions[en->enemyparama]))(en);
	
	// Return
	return 1;
}
