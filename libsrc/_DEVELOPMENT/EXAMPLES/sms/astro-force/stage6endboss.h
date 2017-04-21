void FinishStage6EndBoss()
{
	// Stop music
	PSGStop();
	
	// Nos cargamos las arañillas
	KillEnemies(1);
	
	// Metemos un enemigo que retrase esto
	InitEnemy(0,0,STAGE6OBJECT);
}

void ResetSkullState(enemy *en,unsigned int st,unsigned char rec)
{
	if(rec==1)en->enemyenergy=70;
	en->enemyparama=6;
	en->enemyparamb=st;
	en->enemyframe=0;
}

void DoSkullSinusMovement(enemy *en,unsigned char dv,unsigned char offset)
{
	if(en->enemyparamb==0)
	{
		en->enemyposx-=dv;
		if(en->enemyposx<24+offset)en->enemyparamb=1;
	}
	else
	{
		en->enemyposx+=dv;
		if(en->enemyposx>(256-en->enemywidth-48+offset))en->enemyparamb=0;
	}
}

void CreateCustomBoneC(unsigned char x, unsigned char y, unsigned char vx, unsigned char vy)
{
	enemy *enm;
	InitEnemy(x,y,SKULLBONEC);
	enm=&enemies[numenemies-1];
	enm->enemyparama=vx;
	enm->enemyparamb=vy;
}


void LaunchSkullBoneC(enemy *en,unsigned char vy)
{
	if(numenemies<4)
	if(en->enemyframe%80==0)
	{
		CreateCustomBoneC(en->enemyposx-16,en->enemyposy+20,0,vy);
		CreateCustomBoneC(en->enemyposx+40,en->enemyposy+20,16,vy);
	}
}

void DoSkullShootDirection(enemy *en)
{
	if(en->enemyframe%64==32)
		SpreadEnemyshootDirection(en->enemyposx+16,en->enemyposy+56,skullshootvelx,skullshootvely,7);
}

void DoSkullShootDirectionB(enemy *en)
{
	unsigned char a;
	
	if(en->enemyframe%24==0)
		for(a=0;a<2;a++)
			InitEnemyshoot(en->enemyposx+(myRand()%32),en->enemyposy+(myRand()%48),1);
}

void UpdateStage6EndBoss0(enemy *en)
{
	en->enemyposy++;
	if(en->enemyposy>=30)
		ResetSkullState(en,1,1);
}

void UpdateStage6EndBoss1(enemy *en)
{
	// Jump to other state
	if(en->enemyenergy<10)
	{
		ResetSkullState(en,2,1);
	}
	else
	{
		// Sinus movement
		DoSkullSinusMovement(en,1,0);
		
		// Launch bones
		if(numenemies<4)
			if(en->enemyframe%16==0)
				InitEnemy(en->enemyposx+(myRand()%24),en->enemyposy+56,SKULLBONEA);

		// Shoot
		DoSkullShootDirection(en);
	}
}

void UpdateStage6EndBoss2(enemy *en)
{
	// Jump to other state
	if(en->enemyenergy<10)
		ResetSkullState(en,3,1);		
	else
	{
		// Sinus movement
		DoSkullSinusMovement(en,2,0);

		// Bones
		if(numenemies<4)
			if(en->enemyframe%12==0)
				InitEnemy(en->enemyposx+(myRand()%24),en->enemyposy+56,SKULLBONEB);

		// Shoots
		DoSkullShootDirectionB(en);
	}
}

void UpdateStage6EndBoss3(enemy *en)
{
	// Jump to other state
	if(en->enemyenergy<10)
		ResetSkullState(en,4,1);
	else
	{
		if(en->enemyframe%48==16)
			CreateCustomBoneC(en->enemyposx-16,en->enemyposy+16,0,0);
		if(en->enemyframe%48==32)
			CreateCustomBoneC(en->enemyposx+40,en->enemyposy+16,16,0);
		
		if(playerx+16<en->enemyposx+20)en->enemyposx-=2;
		else if(playerx>en->enemyposx+20)en->enemyposx+=2;
		else
		{
			InitEnemy(en->enemyposx+8,en->enemyposy+24,VULCANLASER);
			InitEnemy(en->enemyposx+24,en->enemyposy+24,VULCANLASER);
			ResetSkullState(en,3,0);			
		}
	}
}

void UpdateStage6EndBoss3A(enemy *en)
{
	// Jump to other state
	if(en->enemyenergy<10)
		en->enemyenergy=10;

	// Wait
	if(en->enemyframe>35)
	{
		en->enemyparama=en->enemyparamb;
		en->enemyframe=0;
	}
}

void UpdateStage6EndBoss4(enemy *en)
{
		
	// Jump to other state
	if(en->enemyenergy<10)
		ResetSkullState(en,5,1);
	else
	{
		// Sinus movement
		DoSkullSinusMovement(en,3,0);
		
		// Launch bones
		LaunchSkullBoneC(en,0);

		// Shooting
		if(en->enemyframe%12==0)
			InitEnemyshoot(en->enemyposx+(myRand()%32),en->enemyposy+(myRand()%48),1);
	}
}

void UpdateStage6EndBoss5(enemy *en)
{
	unsigned char a;
			
	if(playerx+16<en->enemyposx)en->enemyposx--;
	if(playerx>en->enemyposx+40)en->enemyposx++;
	if(playery+16<en->enemyposy)en->enemyposy--;
	if(playery>en->enemyposy+40)en->enemyposy++;

	// Launch bones
	LaunchSkullBoneC(en,8);
	
	// Shooting
	if(en->enemyframe%8==0)
	{
		a=(en->enemyframe>>3)%16;
		InitEnemyshootDirection(en->enemyposx+20,en->enemyposy+28,skullbshootvelx[a],skullbshootvely[a]);
	}
}

unsigned char UpdateStage6EndBoss(enemy *en)
{
	// Draw
	DrawSpriteArray(STAGE6ENDBOSSBASE,en->enemyposx,en->enemyposy,40,56);

	// Call custom function
	//changeBank(FIXEDBANKSLOT);
	(*(updatestage6endbossfunctions[en->enemyparama]))(en);

	// Exit
	return 1;
}

