unsigned char getTileAt(unsigned char x,unsigned char y)
{
	unsigned int nl;
	unsigned char t;
	
	// The bank!!!
	changeBank(mapbank);
	
	// The collision
	nl=maplines[((mappositiony>>2)+y)>>3];
	nl=(nl<<6)+((x>>3)<<1);
	t=maptiles[nl];
	
	changeBank(FIXEDBANKSLOT);
	
	return t;
}
	
void SetMapLines(unsigned char *lines, unsigned int lsize,unsigned char *tiles)
{
	maplines=lines;
	maplineslength=lsize;
	maptiles=tiles;
}

void SetStaticEnemies(unsigned int *p, unsigned char b)
{
	mapstatics=p;
	mapstaticsbank=b;
	mapstaticscount=0;
}

void DrawMap()
{
	// To cache things
	int a=mappositiony>>5;
	
	// Change bank if needed
	changeBank(mapbank);
	
	// Draw all lines
	for(int b=0;b<28;b++)
	{
		int c=(b+a)%maplineslength;
		c=maplines[c];
		SMS_loadTileMap(0,b,maptiles+(c<<6),64);
	}
	
	// Saving old position
	oldmappositiony=mappositiony;
	
	// Reset scroll
	SMS_setBGScrollX (0);
	SMS_setBGScrollY (0);
}

void InitMap(unsigned char mb)
{
	mappositionx=0;
	mappositiony=(maplineslength<<5)-(28<<5);
	mapbank=mb;
	mapstatics=0;
	DrawMap();
}

void MoveMap(signed int mvx,signed int mvy)
{
	int a,c;
	unsigned int mpy2,mpy5;
	
	// Movement
	mappositionx+=mvx;
	mappositiony+=mvy;
	
	// Cache
	mpy2=mappositiony>>2;
	mpy5=mpy2>>3;
	
	// Update scroll
	UpdateScroll((mappositionx>>2)%256,mpy2%224);
	
	// Have to refill???
	if(mpy5!=oldmappositiony>>5)
	{
		// Change the bank
		changeBank(mapbank);
		
		// Load lines
		a=mpy5%maplineslength;

		// Load lines
		a=(mpy5)%maplineslength;
		c=maplines[a];
		SMS_loadTileMap(0,((mpy2)%224)>>3,maptiles+(c<<6),64);
		
		// Change bank if needed
		changeBank(FIXEDBANKSLOT);
		
		//OPTIMIZED TEST
		//UNSAFE_SMS_VRAMmemcpy64 (SMS_PNTAddress|((unsigned int)((mpy2%224)>>3)<<6), maptiles+(maplines[a]<<6));
		
		// Put enemies if needed
		if (mapstatics!=0)
		{
			// Put all enemies
			while(mapstatics[mapstaticscount]==a)
			{
				InitEnemy(mapstatics[mapstaticscount+2],
						  mapstatics[mapstaticscount+3],
						  mapstatics[mapstaticscount+1]);
				mapstaticscount+=4;
			}
		}
	}
	
	// Save last position
	oldmappositiony=mappositiony;
}