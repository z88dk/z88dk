void InitStage1MiddleBossC(enemy *en)
{
	en->enemyparamb=(myRand()%2)*16;
}


unsigned char UpdateStage1MiddleBossC(enemy *en)
{
	// AccelerationY
	en->enemyparama++;
	
	// Acceleration X
	if(en->enemyframe%2==0)
		SkullAccelX(en);
	
	// Movement
	SkullBoneCMove(en);
	
	// Kill???
	if(en->enemyposy>192)return 0;
	
	// Sprite
	DrawQuadSprite(en->enemyposx,en->enemyposy,STAGE1MIDDLEBOSSBASE+20);
	
	return 1;
}

