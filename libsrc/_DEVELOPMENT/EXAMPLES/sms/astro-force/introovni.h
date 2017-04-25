unsigned char UpdateIntroOvni(enemy *en)
{
	// Draw
	DrawQuadSprite(en->enemyposx,en->enemyposy,INTROOVNIBASE+(((en->enemyframe>>2)%4)<<2));
	
	// Update
	if(en->enemytype==INTROOVNILEFT)
	{
		if(en->enemyposx<60)en->enemyposx++;	
	}
	else
	{
		if(en->enemyposx>180)en->enemyposx--;	
	}

	// Return
	return 1;
}

