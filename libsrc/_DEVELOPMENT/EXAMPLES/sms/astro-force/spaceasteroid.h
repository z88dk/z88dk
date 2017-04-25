void InitSpaceAsteroid(enemy *en)
{
	en->enemyparama=en->enemytype+4-52+(myRand()%2);
	en->enemyparamb=myRand()%3;
	en->enemyposx=56+(myRand()%(256-24-56-56));
}

unsigned char UpdateSpaceAsteroid(enemy *en)
{
	en->enemyposy+=en->enemyparama;
	if(en->enemyposy>192)
		return 0;
	else
	{
		en->enemyposx+=en->enemyparamb;
		en->enemyposx-=1;
		if((en->enemyposx<4)||(en->enemyposx>(256-en->enemywidth)))
			return 0;
		else
		{
			// Draw
			if(en->enemytype==SPACEASTEROIDBIG)
				DrawSpriteArray(SPACEASTEROIDBIGBASE,en->enemyposx,en->enemyposy,24,24);
			else if(en->enemytype==SPACEASTEROIDMEDIUM)
				DrawQuadSprite(en->enemyposx,en->enemyposy,(int)(SPACEASTEROIDMEDIUMBASE));
			else
				SMS_addSprite(en->enemyposx,en->enemyposy,(int)(SPACEASTEROIDLITTLEBASE));
		}
	}
	return 1;
}

