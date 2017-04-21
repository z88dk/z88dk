unsigned char UpdateFortressSearcher(enemy *en)
{
	unsigned char p=0;
	
	// Move
	en->enemyposy+=4;
	
	// Exit check
	if((en->enemyposy>192)&&(en->enemyposy<210))
		return 0;

	// Direction
	if((en->enemyposy>80)&&(en->enemyposy<210))
	{
		if (playerx<en->enemyposx-8)
		{
			en->enemyposx-=2;
			p=16;
		}
		else if(playerx>en->enemyposx+8)
		{
			en->enemyposx+=2;
			p=8;
		}
	}
		
	// Draw
	DrawQuadSprite(en->enemyposx,en->enemyposy,FORTRESSSEARCHERBASE+p+(sprite82anim<<2));
	
	// All OK
	return 1;
}

