unsigned char UpdateFortressWave(enemy *en)
{
	en->enemyposy++;
	if(en->enemyposy>192)
		return 0;
	else
	{
		if(en->enemyparama==0)
		{
			en->enemyposx+=2;
			if(en->enemyposx>=26*8)
				en->enemyparama=1;
		}
		else
		{
			en->enemyposx-=2;
			if(en->enemyposx<=4*8)
				en->enemyparama=0;
		}
		DrawQuadSprite(en->enemyposx,en->enemyposy,FORTRESSWAVEBASE);
	}
	return 1;
}

