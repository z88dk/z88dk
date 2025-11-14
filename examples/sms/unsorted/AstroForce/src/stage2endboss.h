void UpdateStage2EndBoss2(enemy *en)
{
	// Do shooting
	if(en->enemyframe%32==8)
		SpreadEnemyshootDirection(en->enemyposx+20,en->enemyposy+32,stage2endbossshootpatternx,stage2endbossshootpatterny,6);
		
	// Move and fire laser
	if(playerx+16<en->enemyposx+23)en->enemyposx-=3;
	else if(playerx>en->enemyposx+25)en->enemyposx+=3;
	else
	{
		InitEnemy(en->enemyposx+20,en->enemyposy+32,VULCANLASER);
		en->enemyparama=3;
		en->enemyframe=0;
	}
}

void UpdateStage2EndBoss1(enemy *en)
{
	DoEnemyWait(en,2);
}

void UpdateStage2EndBoss3(enemy *en)
{
	DoEnemyWait(en,1);
}

unsigned char UpdateStage2EndBoss(enemy *en)
{
	// Draw
	DrawSpriteArray(STAGE2ENDBOSSBASE,en->enemyposx,en->enemyposy,48,48);
	
	// Call custom function
	//changeBank(FIXEDBANKSLOT);
	(*(updatestage2endbossfunctions[en->enemyparama]))(en);
	
	// Return
	return 1;
}

