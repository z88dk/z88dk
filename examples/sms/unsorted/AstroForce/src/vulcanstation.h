void FinishVulcanStation()
{
	// Metemos un enemigo que retrase esto
	InitEnemy(0,0,STAGE2OBJECT);
}

unsigned char UpdateVulcanStation(enemy *en)
{
	unsigned char a;
	
	// When it is stopped is when it shoots!
	if(disablescroll==1)
	{
		a=en->enemyframe%128;

		// Shoot?
		if(a<41)
			if(a%4==0)
				InitEnemyshoot(en->enemyposx+((a%8)<<3),en->enemyposy+24,1);

		if(a>=64)
			if(a%12==0)
				SpreadEnemyshootDirection(en->enemyposx+16,en->enemyposy+24,vulcanstationshootspeedx,vulcanstationshootspeedy,3);
	}
	else
	{
		// Do moving
		en->enemyposy++;
		if(en->enemyframe==48)
		{
			disablescroll=1;
			en->enemyframe=0;
		}
	}

	// Draw
	DrawSpriteArray(VULCANSTATIONBASE,en->enemyposx,en->enemyposy,40,32);
	
	// Return
	return 1;
}

