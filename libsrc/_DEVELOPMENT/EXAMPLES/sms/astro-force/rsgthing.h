unsigned char UpdateRSGThing(enemy *en)
{
	// Exit?
	if(TestSkullOut(en))return 0;		

	// Movement
	UpdateSkullBoneCMovement(en);
	UpdateSkullBoneCMovement(en);
	
	// Sprite
	DrawQuadSprite(en->enemyposx,en->enemyposy,STAGE8BOSSBBASE+120+(sprite82anim<<2));
	
	// Exit
	return 1;
}

void InitRSGThing(enemy *en)
{
	en->enemyparama=(myRand()%2)*16;
	en->enemyparamb=16;
}