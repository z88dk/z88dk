// Remove explosion
void RemoveExplosion(signed char a)
{
	explosion *exa,*exb;
	
	// Remove list of sprites
	if(a<numexplosions-1)
	{
		exa=&explosions[a];
		exb=&explosions[numexplosions-1];
	
		exa->explosionposx=exb->explosionposx;
		exa->explosionposy=exb->explosionposy;
		exa->explosionsprite=exb->explosionsprite;
		exa->explosiontype=exb->explosiontype;			
	}
	// Bajamos el numero de explosions
	numexplosions--;
}

// Update explosion
void UpdateExplosion(unsigned int a)
{
	explosion *ex=&explosions[a];
	
	if(ex->explosiontype==0)
	{
		if(ex->explosionsprite>=6)
			RemoveExplosion(a);
		else
		{
			SMS_addSprite(ex->explosionposx,ex->explosionposy,(ex->explosionsprite>>1)+LITTLEEXPLOSIONBASE);
			ex->explosionsprite++;
		}
	}
	else
	{
		if(ex->explosionsprite>=12)
			RemoveExplosion(a);
		else
		{
			DrawQuadSprite(ex->explosionposx,ex->explosionposy,((ex->explosionsprite>>1)<<2)+BIGEXPLOSIONBASE);
			ex->explosionsprite++;
		}
	}
}

// Create a explosion
void InitExplosion(unsigned char x, unsigned char y,unsigned char t)
{
	explosion *ex;
	
	if(numexplosions<MAXEXPLOSIONS)
	{
		// Get
		ex=&explosions[numexplosions];
		
		// Data
		ex->explosionposx=x;
		ex->explosionposy=y;
		ex->explosionsprite=0;
		ex->explosiontype=t;
		
		// Increase
		numexplosions++;

		// Sound
		if(t!=0)PlaySound(explosion_psg,1);
	}		
}

// Update all explosions
void UpdateExplosions()
{
	// Each of the explosions
	if(numexplosions>0)
		for(signed char a=numexplosions-1;a>=0;a--)
			UpdateExplosion(a);
		
	// Spawn of explosions
	if(spawnedexplosiontime>0)
	{
		if(spawnedexplosiontime%4==0)
		{
			InitExplosion(spawnedexplosionposx+(myRand()%spawnedexplosionwidth),spawnedexplosionposy+(myRand()%spawnedexplosionheight),1);
			DoBarrom();
		}
		spawnedexplosiontime--;		
	}
}

// Init explosion sprite
void InitExplosionSprite()
{
	// Explosion sprite
	LoadSprite(littleexplosion_psgcompr, LITTLEEXPLOSIONBASE,littleexplosion_psgcompr_bank);
	LoadSprite(bigexplosion_psgcompr, BIGEXPLOSIONBASE,bigexplosion_psgcompr_bank);
}

// Init all explosions
void InitExplosions()
{
	InitExplosionSprite();
	numexplosions=0;
	spawnedexplosiontime=0;
}


void InitSpawnedExplosion(unsigned char x, unsigned char y, unsigned char w, unsigned char h)
{
	spawnedexplosionposx=x;
	spawnedexplosionposy=y;
	spawnedexplosionwidth=w-16;
	spawnedexplosionheight=h-16;
	spawnedexplosiontime=(w+h)>>1;
}


