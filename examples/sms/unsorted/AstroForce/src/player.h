void RemovePlayer()
{
	// Set to die
	playertype=4;

	// Constants
	InitPlayerConstants();
	
	// Explosion
	InitExplosion(playerx, playery,1);
	
	// Barrom
	DoBarrom();
	
	// Kill all enemies
	KillEnemyshoots();
	KillEnemies(0);
}


unsigned char CheckPlayerEnemyCollision()
{
	unsigned char a;
	enemy *en;

	#ifdef PLAYERINMUNE
		return 0;
	#endif
	
	// Collision with enemies
	if(numenemies>0)
	for(a=0;a<numenemies;a++)
	{
		en=&enemies[a];
		if(en->enemyposy+en->enemyheight>playery+3)	
			if(en->enemyposy<playery+13)
				if(en->enemyposx<playerx+13)
					if(en->enemyposx+en->enemywidth>playerx+3)
					{
						RemovePlayer();
						return 1;
					}
	}
	return 0;
}

// Collision with enemyshoots
unsigned char CheckPlayerEnemyshootCollision()
{
	unsigned char a;
	enemyshoot *es;

	#ifdef PLAYERINMUNE
		return 0;
	#endif
	
	if(numenemyshoots>0)
	for(a=0;a<numenemyshoots;a++)
	{
		es=&enemyshoots[a];
		if((es->enemyshootposy+5>playery)	
		&&(es->enemyshootposy<playery+13)
		&&(es->enemyshootposx<playerx+13)
		&&(es->enemyshootposx+5>playerx))
		{
			RemovePlayer();
			return 1;
		}
	}
	return 0;
}

// Hearts
void UpdatePlayerIndicators()
{
	for(unsigned char a=0;a<numplayers;a++)
		SMS_addSprite(240-a*8,4,PLAYERINDICATORBASE);
}

// Init a player
void InitPlayer()
{
	// Constants
	playerx=128;
	playery=200;
	playertype=1;
	playercounter=0;
}

// Load player sprite
void InitPlayerSprite()
{
	LoadSprite(player_psgcompr, PLAYERBASE,player_psgcompr_bank);
}

// Draw player sprite
void DrawPlayer()
{
	// Player sprite
	DrawQuadSprite(playerx,playery,PLAYERBASE+playerside);

	// Propulsion
	SMS_addSprite(playerx+4,playery+16,PLAYERBASE+12+sprite82anim);
}

// Move the player
void MovePlayer()
{
	// Move
	if(keystatus&PORT_A_KEY_LEFT)
	{
		playerside=4;
		if(playerx>SPEEDPLAYERSHOOT_SIDE+playerspeed+8)
			playerx-=playerspeed;
	}
	if(keystatus&PORT_A_KEY_RIGHT)
	{
		playerside=8;
		if(playerx<(240-SPEEDPLAYERSHOOT_SIDE-playerspeed))
			playerx+=(playerspeed);
	}
	if(keystatus&PORT_A_KEY_UP)
		if(playery>24)
			playery-=playerspeed;
	if(keystatus&PORT_A_KEY_DOWN)
		if(playery<172)
			playery+=playerspeed;
}

// Check if player can shoot
void CheckShootPlayer()
{	
	// Up to counter
	playershootcounter++;
	
	// Check side
	if(keystatus&PORT_A_KEY_2)
	{
		if(playershootcounter>PLAYERSHOOTINTERVAL_SIDE)
		{
			if(numplayershoots<playershootmax-1)
			{
				playershootcounter=0;
				InitPlayershoot(playerx-8,playery,PLAYERSHOOT_SIDE_LEFT);
				InitPlayershoot(playerx+8,playery,PLAYERSHOOT_SIDE_RIGHT);
			}
		}
	}
	// Check top
	else if(keystatus&PORT_A_KEY_1)
	{
		if(playershootcounter>PLAYERSHOOTINTERVAL_NORMAL)
		{
			if(numplayershoots<playershootmax)
			{
				playershootcounter=0;
				InitPlayershoot(playerx,playery,PLAYERSHOOT_NORMAL);
			}
		}
	}
}

void UpdatePlayerState6()
{
	if(playery>playercounter>>4)
	{
		playery-=playercounter>>4;
		DrawPlayer();
	}
	if(playercounter==160)
	{
		stagenum++;
		exitplaystage=1;
	}
}

void UpdatePlayerState5()
{
	MovePlayer();
	DrawPlayer();
	if(playercounter==80)
	{
		playertype=6;
		PlayMusic(afterboss_psg,afterboss_psg_bank,0);
		playercounter=0;
	}		
}

void UpdatePlayerState4()
{
	if(playercounter>=40)
	{
		numplayers--;
		if(numplayers==0)
		{
			// Game over
			stagenum=0;
			exitplaystage=1;
		}
		else
			// Other player
			InitPlayer();
	}		
}

void UpdatePlayerState3()
{
	unsigned char t=stageframe%6;
	
	// Here the collisions
	if(t==0)
	{
		#ifndef PLAYERINMUNE
			if(CheckMapCollision(playerx+8,playery+8))
			{
				RemovePlayer();
				return;
			}
		#endif
	}
	else if(t==2)
	{
		if(CheckPlayerEnemyCollision()!=0)return;
	}
	else if(t==4)
	{
		if(CheckPlayerEnemyshootCollision()!=0)return;
	}

	// Continue				
	CheckShootPlayer();
	MovePlayer();
	DrawPlayer();
}

void UpdatePlayerState2()
{
	if(playercounter>64)playertype=3;
	CheckShootPlayer();
	MovePlayer();
	// Blitting!!!
	if((playercounter>>1)%2==0)DrawPlayer();		
}

void UpdatePlayerState1()
{
	playery--;
	if(playery<150)
	{
		playertype=2;
		playercounter=0;
	}
	DrawPlayer();		
}

// Update player status
void UpdatePlayer()
{
	// Counter
	playercounter++;

	// Side by default
	playerside=0;
	
	// State
	changeBank(FIXEDBANKSLOT);
		(*(playerupdatefunctions[playertype]))();
}

void InitPlayerConstants()
{
	playerspeed=DEFAULTPLAYERSPEED;
	playershootlevel=0;
	playershootmax=MAXPLAYERSHOOTS-1;
	playercounter=0;
	playershootcounter=0;
}