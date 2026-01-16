void InitVulcanLava(enemy *en)
{
	en->enemyparama=myRand()%7;
}

unsigned char UpdateVulcanLava(enemy *en)
{
	en->enemyposy+=(en->enemyframe>>2);
	en->enemyposy--;
	en->enemyposx+=en->enemyparama;
	en->enemyposx-=3;
	
	if((en->enemyposy>192)||
		(en->enemyposx<4)||
		(en->enemyposx>256-12))
		return 0;
	
	SMS_addSprite(en->enemyposx,en->enemyposy,VULCANLAVABASE+((stageframe>>2)%4));
	return 1;
}

