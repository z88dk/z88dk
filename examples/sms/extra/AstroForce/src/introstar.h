void InitIntroStar(enemy *en)
{
	en->enemyparama=(myRand()%3)+3;
}

unsigned char UpdateIntroStar(enemy *en)
{
	SMS_addSprite(en->enemyposx,en->enemyposy,INTROSTARBASE);
	en->enemyposx-=en->enemyparama;
	return 1;
}

