void DrawPlayerShoot(playershoot *ps)
{
	if(ps->playershoottype==PLAYERSHOOT_NORMAL)
	{
		if(playershootlevel==1)
		{
			SMS_addSprite(ps->playershootx,ps->playershooty,PLAYERSHOOTBASE+1);
			SMS_addSprite(ps->playershootx,ps->playershooty+8,PLAYERSHOOTBASE+2);
			SMS_addSprite(ps->playershootx+8,ps->playershooty,PLAYERSHOOTBASE+1);
			SMS_addSprite(ps->playershootx+8,ps->playershooty+8,PLAYERSHOOTBASE+2);
		}
		else
		{
			SMS_addSprite(ps->playershootx+4,ps->playershooty,PLAYERSHOOTBASE+1);
			SMS_addSprite(ps->playershootx+4,ps->playershooty+8,PLAYERSHOOTBASE+2);
		}
	}
	else
	{
		if(playershootlevel==1)
		{
			SMS_addSprite(ps->playershootx-2,ps->playershooty,PLAYERSHOOTBASE+ps->playershoottype);
			SMS_addSprite(ps->playershootx+10,ps->playershooty,PLAYERSHOOTBASE+ps->playershoottype);
		}
		else SMS_addSprite(ps->playershootx+4,ps->playershooty,PLAYERSHOOTBASE+ps->playershoottype);
	}
}
		
// Load playershootsprites
void InitPlayershootSprites()
{
	LoadSprite(playershoot_psgcompr, PLAYERSHOOTBASE,playershoot_psgcompr_bank);
}

// Remove playershoot
void RemovePlayershoot(signed char a)
{
	playershoot *psa,*psb;
	
	// Remove list of sprites
	if(a<numplayershoots-1)
	{
		psa=&playershoots[a];
		psb=&playershoots[numplayershoots-1];
		
		psa->playershootx=psb->playershootx;
		psa->playershooty=psb->playershooty;
		psa->playershoottype=psb->playershoottype;
		psa->playershootvelx=psb->playershootvelx;
		psa->playershootvely=psb->playershootvely;
	}
	// Bajamos el numero de player shoots
	numplayershoots--;
}

// Update player shoot
void UpdatePlayershoot(unsigned int a)
{
	enemy *en;
	signed char b;
	
	// Get player shoot
	playershoot *ps=&playershoots[a];

	// outside
	if((ps->playershooty<SPEEDPLAYERSHOOT_NORMAL)||(ps->playershootx<SPEEDPLAYERSHOOT_SIDE)||(ps->playershootx>248-SPEEDPLAYERSHOOT_SIDE))
		RemovePlayershoot(a);	
	else 
	{
		// Move
		ps->playershootx+=ps->playershootvelx;
		ps->playershooty-=ps->playershootvely;

		// Collision
		if(stageframe2mod==0)
		if(CheckMapCollision(ps->playershootx+8,ps->playershooty+4))
		{
			InitExplosion(ps->playershootx+4,ps->playershooty+4,0);
			RemovePlayershoot(a);
		}
		
		// Collision with enemies
		else
		{
			if(numenemies>0)
			{
				for(b=numenemies-1;b>=0;b--)
				{
					en=&enemies[b];
					if(checkEnemyPlayerShoot(en,ps)==1)
					{
						if(en->enemyenergy<=1+playershootlevel)
							KillEnemy(b);
						else
						{
							en->enemyenergy-=(1+playershootlevel);
							InitExplosion(ps->playershootx+4,ps->playershooty+4,0);
						}
					
						// Remove in all cases
						RemovePlayershoot(a);
						
						// No more collisions nor draws
						return;
					}	
				}
			}
		}
		
		// Draw 
		DrawPlayerShoot(ps);
	}
}

// Update all player shoots
void UpdatePlayershoots()
{
	// Do movement
	if(numplayershoots>0)
		for(signed char a=numplayershoots-1;a>=0;a--)
			UpdatePlayershoot(a);
}

// Create a player shoot
void InitPlayershoot(unsigned char x, unsigned char y,unsigned char t)
{
	playershoot *ps;
	
	// Get next item
	ps=&playershoots[numplayershoots++];
	
	// Config
	ps->playershootx=x;
	ps->playershooty=y;
	ps->playershoottype=t;

	// Get speed
	changeBank(FIXEDBANKSLOT);
	ps->playershootvelx=playershootspeedsx[t];
	ps->playershootvely=playershootspeedsy[t];
}

void InitPlayershoots()
{
	// Playershoot sprites
	InitPlayershootSprites();
	
	// Reset counter
	numplayershoots=0;
}