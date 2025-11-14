void InitTurnShip(enemy *en)
{
	en->enemyparama=en->enemyposx>128?0:2;
	en->enemyparamb=64;
}

unsigned char UpdateTurnShip(enemy *en)
{
	// Vertical movement
	en->enemyposy+=4;
	if(en->enemyposy>192)
		return 0;

	// Draw
	DrawQuadSprite(en->enemyposx,en->enemyposy,TURNSHIPBASE+sprite164anim);
	
	// Shoot?
	TestEnemyShootOne(en,6);

	// Movement
	en->enemyposx+=en->enemyparamb-64;
	if(en->enemyframe%8==0)
		en->enemyparamb+=en->enemyparama-1;
	
	return 1;
}

