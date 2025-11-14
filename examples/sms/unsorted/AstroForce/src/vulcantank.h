unsigned char UpdateVulcanTankCommon(enemy *en)
{
	if(disablescroll==0)
	{
		en->enemyposy++;
		if(en->enemyposy>192)return 0;
	}	
	return 1;
}

unsigned char UpdateVulcanTankLeft(enemy *en)
{
	// Movement
	if(UpdateVulcanTankCommon(en)==0)return 0;
	if(en->enemyposx<80)en->enemyposx++;
	
	// Shooting
	if(playerx>en->enemyposx+16)TestEnemyShoot(en,19);
	
	// Draw
	DrawQuadSprite(en->enemyposx,en->enemyposy,VULCANTANKBASE+(en->enemyposx<80?((en->enemyframe%2)<<2):0));
	
	// Return 
	return 1;
}

unsigned char UpdateVulcanTankRight(enemy *en)
{
	// Movement
	if(UpdateVulcanTankCommon(en)==0)return 0;
	if(en->enemyposx>160)en->enemyposx--;
	
	// Shooting
	if(playerx+16<en->enemyposx)TestEnemyShoot(en,19);
	
	// Draw
	DrawQuadSprite(en->enemyposx,en->enemyposy,VULCANTANKBASE+8+(en->enemyposx>160?((en->enemyframe%2)<<2):0));
	
	// Return
	return 1;
}

unsigned char UpdateVulcanTankStop(enemy *en)
{
	unsigned char a;
	
	// Movement
	if(UpdateVulcanTankCommon(en)==0)return 0;
	
	// Shooting
	a=en->enemyframe%100;
	if((a==0)||(a==30))
		SpreadEnemyshootDirection(en->enemyposx+4,en->enemyposy+8,vulcantankshootspeedx,vulcantankshootspeedy,3);
	
	// Draw
	DrawQuadSprite(en->enemyposx,en->enemyposy,VULCANTANKBASE+16);
	
	// Return
	return 1;
}
			



