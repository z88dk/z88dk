void InitWW2Plane(enemy *en)
{
	const unsigned char *pat;

	// El parama
	en->enemyparama=en->enemytype-WW2PLANE_TYPE_A;
	
	// El pat
	pat=ww2plane_patterns[en->enemyparama];
	
	// La posicion inicial
	en->enemyposx=pat[0];
	en->enemyposy=pat[1];
	
	// Donde estamos
	en->enemyparamb=2;
}

unsigned char UpdateWW2Plane(enemy *en)
{
	unsigned char p;
	const unsigned char *pat;

	// El pat
	pat=ww2plane_patterns[en->enemyparama];
	
	// Saltamos
	while(en->enemyframe>=pat[en->enemyparamb])en->enemyparamb+=2;
	
	// El patron
	p=pat[en->enemyparamb+1];
	
	// Si tenemos que salirnos
	if(p==WW2PLANE_END)return 0;
	
	// El movimiento
	en->enemyposx+=ww2planemovementx[p];
	en->enemyposy+=ww2planemovementy[p];
	
	// El sprite
	DrawQuadSprite(en->enemyposx,en->enemyposy,WW2PLANEBASE+(p<<2));
	
	// Shoot
	TestEnemyShoot(en,31);

	// Done!
	return 1;
}
