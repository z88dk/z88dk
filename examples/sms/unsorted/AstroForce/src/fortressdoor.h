unsigned char UpdateFortressDoor(enemy *en)
{
	en->enemyposy++;
	
	if(en->enemyposy>192)
		return 0;
	else
		DrawSpriteArray(FORTRESSDOORBASE,en->enemyposx-8,en->enemyposy,32,8);
		DrawSpriteArray(FORTRESSDOORBASE,en->enemyposx-8,en->enemyposy+8,32,8);
	return 1;
}

