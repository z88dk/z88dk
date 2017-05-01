void InitFortressPhantom(enemy *en)
{
	GetEnemyDirection(en);
}

unsigned char UpdateFortressPhantom(enemy *en)
{
	if(en->enemyframe>=16)
	{
		if(TestSkullOut(en))
			return 0;
		else
		{
			en->enemyposx+=en->enemyparama;
			en->enemyposy+=en->enemyparamb;
			DrawQuadSprite(en->enemyposx,en->enemyposy,FORTRESSPHANTOMBASE+12);
		}
	}
	else DrawQuadSprite(en->enemyposx,en->enemyposy,FORTRESSPHANTOMBASE+((en->enemyframe>>2)<<2));
	return 1;
}

