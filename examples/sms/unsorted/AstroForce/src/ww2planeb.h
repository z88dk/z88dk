unsigned char UpdateWW2PlaneB(enemy *en)
{
	DrawQuadSprite(en->enemyposx,en->enemyposy,WW2PLANEBASE+12);
	
	if((en->enemyposy>192)&&(en->enemyposy<210))
		return 0;
	else
	{
		// Move
		en->enemyposy+=5;
		
		// Shoot?
		//TestEnemyShootOne(en,3);
	}
	return 1;
}


