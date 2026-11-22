void InitMonsterMissilLeft(enemy *en)
{
	en->enemyparama=8;
}

unsigned char UpdateMonsterMissil(enemy *en)
{
	en->enemyposy++;
	
	if(en->enemyposy>192)
		return 0;
	else
	{
		// Draw sprite
		DrawQuadSprite(en->enemyposx,en->enemyposy,MONSTERMISSILBASE+en->enemyparama+(playery<en->enemyposy?4:0));

		// Enemy shoot?
		DoSideShoot(en,15);
	}
	return 1;
}
