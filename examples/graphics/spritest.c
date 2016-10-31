/* Sample for the putsprite command.
   We draw some garbage on the screen, 
   then we put a masked arrow.
   It can be moved using 'q,a,o,p'; SPACE exits. 
   Improved version; the mask is drawn AFTER the sprite,
   so we reduce the flicker, and being the mask just "a border",
   it is put faster. */

// zcc +zx -vn spritest.c -o spritest -lndos -create-app

#include <stdio.h>
#include <games.h>
#include <ctype.h>

char bullet[] = 
	{ 11,3,
		'\xE0', '\xE0', 
		'\xBF', '\xA0', 
		'\xE0', '\xE0'
	};

char arrow[] = 
	{ 8,8,
		'\x00',
		'\x60',
		'\x70',
		'\x78',
		'\x7C',
		'\x18',
		'\x0C',
		'\x00'
	};
	

char arrow_mask[] = 
	{ 8,8,
		'\xE0',
		'\x90',
		'\x88',
		'\x84',
		'\x82',
		'\xE6',
		'\x12',
		'\x1E'
	};

char arrow_bk[] = 
	{ 8,8,
	  0,0,
	  0,0,0,0,0,0,0,0,
	  0,0,0,0,0,0,0,0
	};

/*
extern char bullet[];
extern char arrow[];
extern char arrow_mask[];
extern char arrow_bk[];

#asm
.smc_bullet
 defb	11,3
 defb	@11100000, @11100000
 defb	@10111111, @10100000
 defb	@11100000, @11100000

.smc_arrow
 defb	8,8
 defb	@00000000
 defb	@01100000
 defb	@01110000
 defb	@01111000
 defb	@01111100
 defb	@00011000
 defb	@00001100
 defb	@00000000
 
.smc_arrow_mask
 defb	8,8
 defb	@11100000
 defb	@10010000
 defb	@10001000
 defb	@10000100
 defb	@10000010
 defb	@11100110
 defb	@00010010
 defb	@00011110


.smc_arrow_bk
 defb	8,8
 defw	0
 defb	0,0,0,0,0,0,0,0
 defb	0,0,0,0,0,0,0,0

#endasm
*/

main()
{
int x,y,z;
int flag=1;
int speed=1;
char *ptr;

  //printf("%c",12);		//clear screen
  for (x=10; x<39; x=x+3)	//put some trash on screen
  {
	putsprite(spr_or,2*x,x,bullet);
	putsprite(spr_or,2*x-10,x,bullet);
	putsprite(spr_or,2*x+10,x,bullet);
  }
  //printf("Sprite demo");

  x=40;
  y=20;
  
  bksave(x,y,arrow_bk);
  
  while (flag!=2)
	{
	        switch( getk() ) {
	                case 'q':
	                	y=y-speed;
	                	flag=1;
	                        break;
	                case 'a':
	                	y=y+speed;
	                	flag=1;
	                        break;
	                case 'p':
	                	x++;
	                	flag=1;
	                        break;
	                case 'o':
	                	x--;
	                	flag=1;
	                        break;
	                case 32:
	                        flag=2;
	                        break;
	                default:
	                	speed=1;
	        }
	        
	        if (flag==1)
	        {
	           if (speed<4) speed=speed+1;
		   bkrestore(arrow_bk);
		   bksave(x,y,arrow_bk);
		   putsprite(spr_or,x,y,arrow);
		   putsprite(spr_mask,x,y,arrow_mask);
		   flag=0;
		}
	}
}

