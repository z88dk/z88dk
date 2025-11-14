void InitVulcanBird(enemy *en)
{
	en->enemyparama=8;
	en->enemyparamb=8;
}

unsigned char UpdateVulcanBird(enemy *en)
{
	if(en->enemyframe<12)
	{
		en->enemyposy++;
		DrawQuadSprite(en->enemyposx,en->enemyposy,VULCANBIRDBASE+12+((en->enemyframe>>2)<<2));
	}
	else
	{
		// Update Y
		SkullAccelX(en);

		// Update X
		en->enemyparama++;
		SkullBoneCMove(en);
		
		// Exit test
		if(en->enemyposy>192-16)return 0;
		
		// Draw vulcan bird
		DrawQuadSprite(en->enemyposx,en->enemyposy,VULCANBIRDBASE+sprite164anim);
		
		// Shoot?
		TestEnemyShootOne(en,18);
	}
	return 1;
}

