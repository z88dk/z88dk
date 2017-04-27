unsigned char UpdateMonsterBlob(enemy *en)
{
	if(en->enemyframe>=30)
		// Looping
		en->enemyframe=0;
	else
	if(en->enemyframe>5)
	{
		// Movement
		en->enemyposx+=en->enemyparama;
		en->enemyposy+=en->enemyparamb;
	}
	else
	if(en->enemyframe==5)
		// New direction
		GetEnemyDirection(en);
	
	// Animated sprite
	DrawQuadSprite(en->enemyposx,en->enemyposy,MONSTERBLOBBASE+sprite164anim);

	return 1;
}

