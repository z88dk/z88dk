/* Sample for the putsprite command.
   We draw some garbage on the screen,
   then we put a masked arrow.
   It can be moved using arrows; ENTER exits.
   Improved version; the mask is drawn AFTER the sprite,
   so we reduce the flicker, and being the mask just "a border",
   it is put faster. */

#pragma string name Sprite/Mouse test
#pragma output nostreams
#pragma data icon 0x00,0x60,0x70,0x78,0x7C,0x18,0x0C,0x00;

#include <stdio.h>
#include <games.h>

#if defined __TI82__ || defined __TI83__ || defined __TI8x__
#define SCREENX 96
#define SCREENY 64
#endif

#if defined __TI85__ || defined __TI86__
#define SCREENX 128
#define SCREENY 64
#endif

char bullet[] =
	{ 11,3,
		0xE0, 0xE0, /* defb @11100000, @11100000 */
		0xBF, 0xA0, /* defb @10111111, @10100000 */
		0xE0, 0xE0  /* defb @11100000, @11100000 */
	};

char arrow[] =
	{ 8,8,
		0x00, /* defb @00000000 */
		0x60, /* defb @01100000 */
		0x70, /* defb @01110000 */
		0x78, /* defb @01111000 */
		0x7C, /* defb @01111100 */
		0x18, /* defb @00011000 */
		0x0C, /* defb @00001100 */
		0x00  /* defb @00000000 */
	};

char arrow_mask[] =
	{ 8,8,
		0xE0, /* defb @11100000 */
		0x90, /* defb @10010000 */
		0x88, /* defb @10001000 */
		0x84, /* defb @10000100 */
		0x82, /* defb @10000010 */
		0xE6, /* defb @11100110 */
		0x12, /* defb @00010010 */
		0x1E  /* defb @00011110 */
	};

char arrow_bk[] =
	{ 8,8,
	  0,0,
	  0,0,0,0,0,0,0,0,
	  0,0,0,0,0,0,0,0
	};

main()
{
	int x,y,z;
	int flag  = 1;
	int speed = 1;
	char *ptr;
	for (x=10; x<39; x+=3)
	{
		putsprite(spr_or,2*x   ,x,bullet);
		putsprite(spr_or,2*x-10,x,bullet);
		putsprite(spr_or,2*x+10,x,bullet);
	}

	x=40;
	y=20;

	bksave(x,y,arrow_bk);

	while(flag!=2)
	{
		switch(getk())
		{
			case 11: /* arrow up */
			  y-=speed;
			  flag=1;
			  break;
			case 10: /* arrow down */
			  y+=speed;
			  flag=1;
			  break;
			case 9:  /* arrow right */
			  x+=speed;
			  flag=1;
			  break;
			case 8:  /* arrow left */
			  x-=speed;
			  flag=1;
			  break;
			case 13: /* [Enter] */
			  flag=2;
			  break;
			default: /* reset speed */
			  speed=1;
			  break;
		}
		if(x<0) x=0;
		if(y<0) y=0;
		if(x>(SCREENX-8)) x=(SCREENX-8);
		if(y>(SCREENY-8)) y=(SCREENY-8);
		if(flag==1)
		{
			if(speed<3)
			speed++;

			bkrestore(arrow_bk);
			bksave(x,y,arrow_bk);
			putsprite(spr_or,x,y,arrow);
			putsprite(spr_mask,x,y,arrow_mask);
			flag = 0;
		}
	}
}
