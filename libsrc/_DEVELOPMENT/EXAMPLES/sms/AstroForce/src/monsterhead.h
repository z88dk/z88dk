unsigned char UpdateMonsterHead(enemy *en)
{
	en->enemyposy++;
	if(en->enemyposy>192)return 0;

	// Image
	DrawSpriteArray(MONSTERHEADBASE+((sprite164anim>>2)*9),en->enemyposx,en->enemyposy,24,24);
	
	// Shooting
	if(en->enemyframe%5==0)
	{
		changeBank(FIXEDBANKSLOT);
		InitEnemyshootDirection(en->enemyposx+8,en->enemyposy+8,monsterheadshootdirecionsx[en->enemyparama],en->enemyposy>96?-monsterheadshootdirecionsy[en->enemyparama]:monsterheadshootdirecionsy[en->enemyparama]);
		en->enemyparama++;
		en->enemyparama%=16;
	}

	// Exit
	return 1;
}

