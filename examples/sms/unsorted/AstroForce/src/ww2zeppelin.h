void InitWW2Zeppelin(enemy *en)
{
	en->enemyposx+=(myRand()%32)-16;
}

unsigned char UpdateWW2Zeppelin(enemy *en)
{
	if(en->enemyposy>192)
		return 0;
	else
	{
		// Zeppelin
		DrawSpriteArray(WW2ZEPPELINBASE,en->enemyposx,en->enemyposy,16,24);
		
		// Propulsion
		SMS_addSprite(en->enemyposx+4,en->enemyposy-8,WW2ZEPPELINBASE+6+sprite82anim);

		// Slow movement
		if(stageframe4mod==1)
			en->enemyposy+=1;

		// Shoot?
		TestEnemyShoot(en,21);
	}
	return 1;
}

