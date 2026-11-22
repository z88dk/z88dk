void InitSpreadShip(enemy *en)
{
	en->enemyposx=56+(myRand()%128);
}

unsigned char UpdateSpreadShip(enemy *en)
{
	DrawQuadSprite(en->enemyposx,en->enemyposy,SPREADSHIPBASE);
	SMS_addSprite(en->enemyposx+4,en->enemyposy-8,SPREADSHIPBASE+4+sprite82anim);
	
	if(en->enemyframe<30)
		en->enemyposy=en->enemyframe<<1;
	else if(en->enemyframe<60)
	{
		if(en->enemyframe==45)
			SpreadEnemyshootDirection(en->enemyposx+4,en->enemyposy+8,vulcantankshootspeedx,vulcantankshootspeedy,3);
	}
	else if(en->enemyframe<90)
		en->enemyposy=((90-en->enemyframe)<<1);
	else return 0;
	return 1;
}

