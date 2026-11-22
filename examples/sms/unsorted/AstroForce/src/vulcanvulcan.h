unsigned char UpdateVulcanVulcan(enemy *en)
{
	en->enemyposy++;
	
	if(en->enemyposy>192)
		return 0;

	SMS_addSprite(en->enemyposx,en->enemyposy-8,VULCANVULCANBASE+((stageframe>>2)%4));
	
	
	if(en->enemyposy<144)
		if((en->enemyframe%8)==0)
			InitEnemy(en->enemyposx,en->enemyposy,VULCANLAVA);
	return 1;
}

