void InitIntroSidePlayer(enemy *en)
{
	en->enemyparama=en->enemyposx;
}

unsigned char UpdateIntroSidePlayer(enemy *en)
{
	unsigned int a;
	
	// Player
	DrawQuadSprite(en->enemyposx,en->enemyposy,INTROSIDEPLAYERBASE);
	
	// Propulsion
	SMS_addSprite(en->enemyposx-8,en->enemyposy+4,INTROSIDEPLAYERBASE+4+((stageframe>>2)%2));

	// Updating
	a=en->enemyparama==0?752:910;
	
	if(stageframe<a)
	{
		a-=stageframe;
		
		if(en->enemyposx<128)en->enemyposx++;
		en->enemyposy=72+((sinus(a)*3)>>4);
	}
	else
	{
		en->enemyposx+=4;
		if(en->enemyposx>240)return 0;
	}
	return 1;
}

