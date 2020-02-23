
/* 2 dices roll simulation */

	#include <stdio.h>
	#include <stdlib.h>
	#include <graphics.h>
	#include <games.h>

	char dot[] = { 
			3,3,
			0xE0,0xA0,0xE0
			};

	char numbers[] = { 
			4,5,
			0x70,0x90,0,0x90,0xE0,
			4,5,
			0x20,0x20,0,0x40,0x40,
			4,5,
			0x70,0x10,0x60,0x80,0xE0,
			4,5,
			0x70,0x10,0x60,0x10,0xE0,
			4,5,
			0x90,0x90,0x60,0x10,0x10,
			4,5,
			0x70,0x80,0x60,0x10,0xE0,
			4,5,
			0x70,0x80,0x60,0x90,0xE0,
			4,5,
			0x70,0x90,0,0x20,0x20,
			4,5,
			0x70,0x90,0x60,0x90,0xE0,
			4,5,
			0x70,0x90,0x60,0x10,0xE0
	};

	int a[13];

	int x,y;

	void main()
	{
		while (1) {
		clg();

		// init
		for (x=2; x<=12; x++) {
			a[x]=0;
			putsprite (spr_or,x*10-20,getmaxy()-6,&numbers[7*(x%10)]);
			if (x>9)
			putsprite (spr_or,x*10-3-20,getmaxy()-6,&numbers[7]);
		}

		// compute
		for (x=0; x<getmaxy(); x++) {
			a[2+rand()%6+rand()%6]++;
		}

		// display
		for (x=1; x<=12; x++)
			for (y=0; y<a[x]; y++)
				putsprite (spr_or,x*10-20,getmaxy()-(y*3)-12,dot);
			
	        while (getk() != '\n') {};
		}
	}

