unsigned char UpdateRectShip(enemy *en)
{
	DrawQuadSprite(en->enemyposx,en->enemyposy,RECTSHIPBASE);
	SMS_addSprite(en->enemyposx+4,en->enemyposy-8,RECTSHIPBASE+4+sprite82anim);
	
	if((en->enemyposy>192)&&(en->enemyposy<210))
		return 0;
	else
	{
		// Move
		en->enemyposy+=7;
		
		// Shoot?
		TestEnemyShootOne(en,3);
	}
	return 1;
}

