unsigned char UpdateSpaceShooter(enemy *en)
{
	// Move
	en->enemyposy++;
	if((en->enemyposy>192)&&(en->enemyposy<200))
		return 0;

	// Draw
	if(playerx<en->enemyposx-16)
		DrawQuadSprite(en->enemyposx,en->enemyposy-4,SPACESHOOTERBASE+4);
	else if(playerx>en->enemyposx+16)
		DrawQuadSprite(en->enemyposx,en->enemyposy-4,SPACESHOOTERBASE+8);
	else
		DrawQuadSprite(en->enemyposx,en->enemyposy-4,SPACESHOOTERBASE);
	

	// Shoot?
	if(playery>en->enemyposy)
		TestEnemyShoot(en,11);	

	// Done
	return 1;
}

