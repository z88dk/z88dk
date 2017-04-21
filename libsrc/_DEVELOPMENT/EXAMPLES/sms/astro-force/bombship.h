void InitBombShipLeft(enemy *en)
{
	en->enemyposx=50+(myRand()%90);
	en->enemyparama=2;
}

void InitBombShipRight(enemy *en)
{
	en->enemyposx=206-(myRand()%90);
}

unsigned char UpdateBombShip(enemy *en)
{
	// Draw
	DrawQuadSprite(en->enemyposx,en->enemyposy,BOMBSHIPBASE+sprite164anim);
	
	// Shoot?
	TestEnemyShoot(en,13);
	
	// X position
	en->enemyposx+=en->enemyparama;
	en->enemyposx-=1;
	
	// Y position
	en->enemyposy=((sinustable[en->enemyframe<<1]-128)*3)>>2;
	
	// Exit???
	return(en->enemyframe<64);
}

