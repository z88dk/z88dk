void DoSideShoot(enemy *en,unsigned char freq)
{
	if(en->enemyframe%freq==0)
	{
		if(en->enemyparama==0)
		{
			if(playerx<en->enemyposx)
				InitEnemyshoot(en->enemyposx+4,en->enemyposy+4,0);
		}
		else
		{
			if(playerx>en->enemyposx)
				InitEnemyshoot(en->enemyposx+4,en->enemyposy+4,0);
		}
	}
}

void InitFortressCannonRight(enemy *en)
{
	en->enemyparama=8;
}

unsigned char UpdateFortressCannon(enemy *en)
{
	en->enemyposy++;
	
	if(en->enemyposy>192)
		return 0;
	else
	{
		// Draw sprite
		DrawQuadSprite(en->enemyposx,en->enemyposy,FORTRESSCANNONBASE+en->enemyparama+(playery<en->enemyposy?4:0));

		// Enemy shoot?
		DoSideShoot(en,13);
	}
	return 1;
}

