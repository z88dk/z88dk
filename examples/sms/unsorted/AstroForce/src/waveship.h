void InitWaveShip(enemy *en)
{
	en->enemyparama=en->enemyposx;
	en->enemyparamb=4+(myRand()%16);
}

unsigned char UpdateWaveShip(enemy *en)
{
	signed int p;
	
	if(en->enemyposy>192)
		return 0;
	else
	{
		// Sinus movement
		en->enemyposy+=2;
		p=(sinus(en->enemyframe<<3)>>2)-32+en->enemyparama;
		en->enemyposx=p;

		// Sprite
		DrawQuadSprite(en->enemyposx,en->enemyposy,WAVESHIPBASE+sprite164anim);

		// Shoot?
		TestEnemyShootOne(en,10);		
	}
	return 1;
}

