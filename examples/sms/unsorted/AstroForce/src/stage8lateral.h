unsigned char UpdateStage8Lateral(enemy *en)
{
	// Out?
	if((en->enemyposx<=4)||(en->enemyposx>=252))
		return 0;
	
	// Move
	en->enemyposx+=(en->enemyparama<<1)-4;
	
	// Draw
	DrawQuadSprite(en->enemyposx,en->enemyposy,STAGE8LATERALBASE+en->enemyparama);
	SMS_addSprite(en->enemyposx+16-(en->enemyparama*6),en->enemyposy+4,STAGE8LATERALBASE+8+sprite82anim);

	// Shoot?
	TestEnemyShootOne(en,50);
	
	// OK
	return 1;
}

void InitStage8Lateral(enemy *en)
{
	en->enemyparama=(en->enemyposx>128?0:4);
}


