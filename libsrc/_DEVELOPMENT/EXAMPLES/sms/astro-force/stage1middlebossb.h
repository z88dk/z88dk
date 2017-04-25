void InitStage1MiddleBossB(enemy *en)
{
	unsigned char a=myRand()%8;
	
	en->enemyparama=Stage1MiddleBossBPatternX[a];
	en->enemyparamb=Stage1MiddleBossBPatternY[a];
}


unsigned char UpdateStage1MiddleBossB(enemy *en)
{
	// Y movement
	en->enemyposy+=en->enemyparamb;
	if(en->enemyposy>192)
		return 0;
	
	// X movement
	en->enemyposx+=en->enemyparama-8;
	if((en->enemyposx<32)||(en->enemyposx>208))en->enemyparama=16-en->enemyparama;
	
	// Sprite
	DrawQuadSprite(en->enemyposx,en->enemyposy,STAGE1MIDDLEBOSSBASE+20);
	
	return 1;
}

