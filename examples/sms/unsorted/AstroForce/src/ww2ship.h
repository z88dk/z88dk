unsigned char UpdateWW2Ship(enemy *en)
{
	DrawQuadSprite(en->enemyposx,en->enemyposy,WW2SHIPBASE);
	
	en->enemyposy+=1;	
	if(en->enemyposy>192)return 0;
	return 1;
}

