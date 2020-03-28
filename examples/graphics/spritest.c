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
#include <graphics.h>

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

/* background for sprite must be (up to) 8 bytes larger than a normal sprite as a work area, current position storage, etc.. */
/* it also depends on the way bksave is implemented */
char arrow_bk[] = 
	{ 8,8,              // size
	  0,0,0,0,0,0,0,0,  // overhead (work area..)
	  0,0,0,0,0,0,0,0,  // data
	  0,0,0,0,0,0,0,0
	};

	

/* Empty sprite to be loaded with getsprite */
char spritest[] = 
	{ 12,12,               // size
		0,0,0,0,0,0,0,0,0,  // data
		0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0
	};
	
	
main()
{
int x,y,z;
int flag=1;
int speed=1;
char *ptr;

  clg();
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
	                case 'Q':
	                	y=y-(1+speed>>1);
	                	flag=1;
	                        break;
	                case 'a':
	                case 'A':
	                	y=y+(1+speed>>1);
	                	flag=1;
	                        break;
	                case 'p':
	                case 'P':
	                	x=x+(1+speed>>1);
	                	flag=1;
	                        break;
	                case 'o':
	                case 'O':
	                	x=x-(1+speed>>1);
	                	flag=1;
	                        break;
	                case ' ':
	                        flag=2;
	                        break;
	                default:
	                	speed=1;
	        }
	        
	        if (flag==1)
	        {
               if (speed<9) speed=speed+1;
               bkrestore(arrow_bk);
               bksave(x,y,arrow_bk);
               putsprite(spr_or,x,y,arrow);
               putsprite(spr_mask,x,y,arrow_mask);
               flag=0;
			}
	}

	bkrestore(arrow_bk);
	getsprite(x,y,spritest);
	undrawb(x-1,y-1,14,14);
	undrawb(x-2,y-2,16,16);
	xorborder(x-2,y-2,16,16);
	clga (0,0,17,17);
	xorborder(0,0,16,16);
	putsprite(spr_or,2,2,spritest);
	
	while (getk() != 0) {};
	while (getk() != ' ') {};
}

