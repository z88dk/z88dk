// Check collision with playershoot
unsigned char checkEnemyPlayerShoot(enemy *en, playershoot *ps)
{
	if((en->enemyposy<ps->playershooty+12)
	   &&(en->enemyposy+en->enemyheight>ps->playershooty)
	   &&(en->enemyposx<ps->playershootx+16)
	   &&(en->enemyposx+en->enemywidth>ps->playershootx))
       return 1;
	return 0;
}

// Get direction to player
void GetEnemyDirection(enemy *en)
{
	signed int dx,dy,dm;
	
	// Better granularity although faster enemy shoots
	dx=playerx-en->enemyposx;
	dy=playery-en->enemyposy;
	dm=abs(dx)+abs(dy);
	dx*=3;
	dy*=3;
	dx/=dm;
	dy/=dm;
	
	en->enemyparama=dx;
	en->enemyparamb=dy;
}

// Remove enemy
void RemoveEnemy(signed char a)
{
	enemy *ea,*eb;
	
	// Remove list of sprites
	if(a<numenemies-1)
	{
		ea=&enemies[a];
		eb=&enemies[numenemies-1];
		
		ea->enemyposx=eb->enemyposx;
		ea->enemyposy=eb->enemyposy;
		ea->enemytype=eb->enemytype;			
		ea->enemyframe=eb->enemyframe;	
		ea->enemyparama=eb->enemyparama;	
		ea->enemyparamb=eb->enemyparamb;	
		ea->enemyenergy=eb->enemyenergy;
		ea->enemywidth=eb->enemywidth;
		ea->enemyheight=eb->enemyheight;
	}
	// Bajamos el numero de enemys
	if(numenemies>0)numenemies--;
}

void KillEnemy(unsigned char a)
{
	enemy *en;
	unsigned char t;
	
	// Security check
	if(a>=numenemies)return;
	
	// Get enemy
	en=&enemies[a];
	
	// Type of explosion
	if(en->enemywidth<=17)
	{
		InitExplosion(en->enemyposx,en->enemyposy,1);
		InitPowerup(en);
	}
	else
		InitSpawnedExplosion(en->enemyposx,en->enemyposy,en->enemywidth,en->enemyheight);

	// Get enemy type
	t=en->enemytype;
	
	// Remove
	RemoveEnemy(a);	

	// Custom remove
	changeBank(FIXEDBANKSLOT);
	if(killenemyfunctions[t]!=0)
		(*(killenemyfunctions[t]))();
}	



void KillEnemies(unsigned char force)
{
	signed char a;
	
	if(numenemies>0)
		for(a=numenemies-1;a>=0;a--)
			if((force==1)||(enemies[a].enemywidth<=16))
				KillEnemy(a);
}


				
// Update enemy
void UpdateEnemy(unsigned char a)
{
	unsigned char erase;
	enemy *en;
	//playershoot *ps;
	
	// Security check
	if(a>=numenemies)return;
	
	// Get enemy
	en=&enemies[a];
	
	// By defect
	erase=1;
	
	// Update
	if(updateenemyfunctions[en->enemytype]!=0)
		erase=(*(updateenemyfunctions[en->enemytype]))(en);
	
	// View if have to erase
	if(erase==0)
		RemoveEnemy(a);
	else
	{
		// Increase counter
		en->enemyframe++;	
		
		/*
		// Collision with player shoot	
		if(a%2==stageframe2mod)
		{
			if(numplayershoots>0)
			{
				for(signed char b=numplayershoots-1;b>=0;b--)
				{
					ps=&playershoots[b];
					if(checkEnemyPlayerShoot(en,ps)==1)
					{
						if(en->enemyenergy<=1+playershootlevel)
							KillEnemy(a);
						else
						{
							en->enemyenergy-=(1+playershootlevel);
							InitExplosion(ps->playershootx+4,ps->playershooty+4,0);
						}
					
						// Remove in all cases
						RemovePlayershoot(b);
						
						// No more collisions
						return;
					}		
				}
			}
		}
		*/
	}
}

// Update all enemys
void UpdateEnemies()
{
	signed char q;
	
	// Need change here, by consensus
	changeBank(FIXEDBANKSLOT);

	// For each enemy
	if(numenemies>0)
		for(q=numenemies-1;q>=0;q--)
			UpdateEnemy(q);
}

// Create a enemy
void InitEnemy(unsigned char x, unsigned char y,unsigned char t)
{
	enemy *en;
	
	if(numenemies<MAXENEMIES)
	{
		// Get enemy
		en=&enemies[numenemies];
		
		// Data
		en->enemyposx=x;
		en->enemyposy=y;
		en->enemytype=t;
		en->enemyframe=0;
		en->enemyparama=0;
		en->enemyparamb=0;
		en->enemywidth=enemieswidth[t];
		en->enemyheight=enemiesheight[t];
		en->enemyenergy=enemiesenergy[t];
		
		// Easy fix
		if((en->enemyenergy>100)&&(en->enemyenergy<255)&&(gamelevel==0))en->enemyenergy-=30;

		// Increase
		numenemies++;
		
		// Init
		if(initenemyfunctions[t]!=0)
			(*(initenemyfunctions[t]))(en);
	}		
}

// Init all enemys
void InitEnemies()
{
	numenemies=0;
}

