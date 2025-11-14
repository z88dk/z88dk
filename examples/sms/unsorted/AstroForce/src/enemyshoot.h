// Load player sprite
void InitEnemyshootSprites()
{
	LoadSprite(enemyshoot_psgcompr, ENEMYSHOOTBASE,enemyshoot_psgcompr_bank);
}

void InitEnemyshootDirection(unsigned char x, unsigned char y, signed char vx, signed char vy)
{
	enemyshoot *es;
	
	shootcount++;
	if(numenemyshoots<MAXENEMYSHOOTS)
	{
		es=&enemyshoots[numenemyshoots];
			
		// Position
		es->enemyshootposx=x;
		es->enemyshootposy=y;
			
		// Type
		es->enemyshoottype=ENEMYSHOOT_NORMAL;
			
		// Set velocity
		es->enemyshootvelx=vx;
		es->enemyshootvely=vy;
			
		// Increment
		numenemyshoots++;
	}
}

void SpreadEnemyshootDirection(unsigned char x, unsigned char y, const signed char *vx, const signed char *vy,unsigned char count)
{
	for(unsigned char a=0;a<count;a++)
		InitEnemyshootDirection(x,y,vx[a],vy[a]);
}


void InitEnemyshootLaser(unsigned char x, unsigned char y)
{
	enemyshoot *es;
	
	shootcount++;
	if(numenemyshoots<MAXENEMYSHOOTS)
	{
		es=&enemyshoots[numenemyshoots];
		
		// Position
		es->enemyshootposx=x;
		es->enemyshootposy=y;
		
		// Type
		es->enemyshoottype=ENEMYSHOOT_LASER;

		// Set velocity
		es->enemyshootvelx=0;
		es->enemyshootvely=DEFAULTENEMYSHOOTLASERSPEED+(gamelevel<<1);
		
		// Increment
		numenemyshoots++;

		// Sound
		PlaySound(enemylaser_psg,1);
	}		
}

// Create a Enemy shoot.. moved here as needed before header file
void InitEnemyshoot(unsigned char x, unsigned char y,unsigned char forced)
{
	signed int dx,dy,dm;
	enemyshoot *es;
	
	shootcount++;
	
	if(numenemyshoots<MAXENEMYSHOOTS)
	{
		if((shootcount%(ENEMYSHOOTDENSITY-gamelevel)==0)||(forced==1))	
		{
			es=&enemyshoots[numenemyshoots];
			
			// Better granularity although faster enemy shoots
			dx=playerx-x;
			dy=playery-y;
			dm=abs(dx)+abs(dy);
			
			// Ahora solo dispara si está relativamente lejos
			if(dm>64)
			{
				// Position
				es->enemyshootposx=x;
				es->enemyshootposy=y;
				
				// Type
				es->enemyshoottype=ENEMYSHOOT_NORMAL;

				// Speed
				dx*=playstageshootspeed;
				dy*=playstageshootspeed;
				dx/=dm;
				dy/=dm;
						
				// Set velocity
				es->enemyshootvelx=dx;
				es->enemyshootvely=dy;
				
				// Increment
				numenemyshoots++;
			}
		}		
	}
}

// Test collision
unsigned char CheckMapCollision(unsigned char x, unsigned char y)
{
	// Updates of stage
	if(stageframe2mod==0)
	{
		changeBank(FIXEDBANKSLOT);
		if(checkcollisionfunctions[playstage]!=0)
			return (*(checkcollisionfunctions[playstage]))(x,y);
	}
	return 0;
}

// Remove enemyshoot
void RemoveEnemyshoot(signed char a)
{
	enemyshoot *esa,*esb;
	
	// Remove list of sprites
	if(a<numenemyshoots-1)
	{
		esa=&enemyshoots[a];
		esb=&enemyshoots[numenemyshoots-1];
		
		esa->enemyshootposx=esb->enemyshootposx;
		esa->enemyshootposy=esb->enemyshootposy;
		esa->enemyshootvelx=esb->enemyshootvelx;
		esa->enemyshootvely=esb->enemyshootvely;
		esa->enemyshoottype=esb->enemyshoottype;
	}
	// Bajamos el numero de enemy shoots
	numenemyshoots--;
}

// Update Enemy shoot
void UpdateEnemyshoot(unsigned int a)
{
	enemyshoot *es=&enemyshoots[a];
	
	if((es->enemyshootposx<8)||(es->enemyshootposx>247)||(es->enemyshootposy<8)||(es->enemyshootposy>183))
		RemoveEnemyshoot(a);
	else
	{
		// Collision
		if(CheckMapCollision(es->enemyshootposx+4,es->enemyshootposy+4))
			RemoveEnemyshoot(a);
		else
		{
			// Movement
			es->enemyshootposx+=es->enemyshootvelx;
			es->enemyshootposy+=es->enemyshootvely;

			// Draw 
			if(es->enemyshoottype==ENEMYSHOOT_NORMAL)
				SMS_addSprite(es->enemyshootposx,es->enemyshootposy,ENEMYSHOOTBASE+sprite82anim);
			else if(es->enemyshoottype==ENEMYSHOOT_LASER)
			{
				SMS_addSprite(es->enemyshootposx,es->enemyshootposy-8,ENEMYSHOOTBASE+2);
				SMS_addSprite(es->enemyshootposx,es->enemyshootposy,ENEMYSHOOTBASE+3);
			}
		}
	}
}

// Update all Enemy shoots
void UpdateEnemyshoots()
{
	// For each
	if(numenemyshoots>0)
		for(signed char a=numenemyshoots-1;a>=0;a--)
			UpdateEnemyshoot(a);
}

void InitEnemyshoots()
{
	InitEnemyshootSprites();
	numenemyshoots=0;
}

void KillEnemyshoots()
{
	numenemyshoots=0;
}

void TestEnemyShoot(enemy *en,unsigned char freq)
{
	if(en->enemyframe%freq==2)
		InitEnemyshoot(en->enemyposx+4,en->enemyposy+4,0);
}

void TestEnemyShootOne(enemy *en,unsigned char freq)
{
	if(en->enemyframe==freq)
		InitEnemyshoot(en->enemyposx+4,en->enemyposy+4,0);
}

void TestEnemyShootComplex(enemy *en,unsigned char freq,unsigned char dx,unsigned char dy)
{
	if(en->enemyframe%freq==2)
		InitEnemyshoot(en->enemyposx+dx,en->enemyposy+dy,1);
}
