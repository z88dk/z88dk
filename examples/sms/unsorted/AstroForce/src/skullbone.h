void SkullAccelX(enemy *en)
{
	
	if((playerx>en->enemyposx)&&(en->enemyparamb<16))en->enemyparamb++;
	if((playerx<en->enemyposx)&&(en->enemyparamb>0))en->enemyparamb--;
}

void SkullAccelY(enemy *en)
{
	
	if((playery>en->enemyposy)&&(en->enemyparama<16))en->enemyparama++;
	if((playery<en->enemyposy)&&(en->enemyparama>0))en->enemyparama--;
}

void SkullBoneCMove(enemy *en)
{
	en->enemyposx+=(en->enemyparamb>>2)-2;		
	en->enemyposy+=(en->enemyparama>>2)-2;
}

void InitSkullBoneA(enemy *en)
{
	GetEnemyDirection(en);
	en->enemyparama<<=1;
	en->enemyparamb<<=1;
}

void InitSkullBoneB(enemy *en)
{
	en->enemyparama=(myRand()%7)-3;
	en->enemyparamb=4;
}

void InitSkullBoneC(enemy *en)
{
	en->enemyparamb=8;
}

unsigned char TestSkullOut(enemy *en)
{
	return ((en->enemyposx<4)||(en->enemyposx>240)||(en->enemyposy<4)||(en->enemyposy>192));
}

unsigned char UpdateSkullBoneAB(enemy *en)
{
	if(TestSkullOut(en))
		return 0;
	else
	{
		// Move
		en->enemyposx+=en->enemyparama;
		en->enemyposy+=en->enemyparamb;
		
		// Draw
		DrawQuadSprite(en->enemyposx,en->enemyposy,SKULLBONEBASE+(((en->enemyframe>>1)%4)<<2));
	}
	return 1;
}

void UpdateSkullBoneCMovement(enemy *en)
{
	// ACCELERATION
	if(en->enemyframe%2==0)
	{
		SkullAccelX(en);
		SkullAccelY(en);
	}
	
	// Movement
	SkullBoneCMove(en);
}

unsigned char UpdateSkullBoneC(enemy *en)
{
	// Exit?
	if(TestSkullOut(en))return 0;		

	// Movement
	UpdateSkullBoneCMovement(en);
	
	// Sprite
	DrawQuadSprite(en->enemyposx,en->enemyposy,SKULLBONEBASE+(((en->enemyframe>>1)%4)<<2));
	
	// Exit
	return 1;
}
