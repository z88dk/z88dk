/*

	Z88DK base graphics libraries examples
	
	A classic 2 players game, the opponents must trap each other.
	
	Build options:
	-DJOYSTICK_DIALOG	- let the players choose their controllers
	-DTEXTSWAP			- ZX81 Graphics <> Text mode swap
	-DPSG -lm			- PSG sound support (e.g. ZON-X on the ZX81, maths library is required)
	
	
	SPEED must be adjusted according to the CPU speed (e.g. must be around 500 on a ZX81):
	
	Commodore 128:
	zcc +c128 -create-app -lgfx128hr -DJOYSTICK_DIALOG -DSPEED=300 snakes.c
	zcc +c128 -create-app -lgfx128 -DJOYSTICK_DIALOG -DSPEED=500 -DPSG -lm snakes.c

	ZX81:
	zcc +zx81 -create-app -DJOYSTICK_DIALOG -DSPEED=300 snakes.c
	zcc +zx81 -create-app -clib=wrx -subtype=wrx -DJOYSTICK_DIALOG -DTEXTSWAP -DSPEED=200 snakes.c
	zcc +zx81 -create-app -clib=arx -subtype=arx -DJOYSTICK_DIALOG -DTEXTSWAP -DSPEED=100 snakes.c
	zcc +zx81 -create-app -clib=udg  -DJOYSTICK_DIALOG -DSPEED=300 snakes.c
	zcc +zx81 -create-app -clib=g007ansi -O3 -DJOYSTICK_DIALOG -DSPEED=200 snakes.c   (SLOW 4 to be added in the BASIC portion)
	
	ZX Spectrum:
	zcc +zx -create-app -lndos -DJOYSTICK_DIALOG -DSPEED=1500 -DPSG -lm snakes.c
	
	
*/

#include <graphics.h>
#include <games.h>

#ifdef JOYSTICK_DIALOG
#include <stdio.h>
#endif

#ifdef PSG
#include <psg.h>
#endif

/* To put the ZX81 graphics page in high memory use the following line:
#pragma output hrgpage = 36096
*/

struct snake {
	int joystick;
	int direction;
	int x;
	int y;
	int x_incr;
	int y_incr;
};

struct snake p1;
struct snake p2;

int x,y;

int crash(int a, int b) {
	for (y=0; y<30; y++) {
		xorplot (a+1,b+1);
		xorplot (a-1,b-1);
		xorplot (a-1,b+1);
		xorplot (a+1,b-1);
		for (x=0; x<SPEED*2; x++) {}
	}
}

int move_snake(struct snake p) {
	
	if (p->direction & MOVE_RIGHT) {
		p->x_incr=1;
		p->y_incr=0;
	}
	if (p->direction & MOVE_LEFT) {
		p->x_incr=-1;
		p->y_incr=0;
	}
	if (p->direction & MOVE_DOWN) {
		p->y_incr=1;
		p->x_incr=0;
	}
	if (p->direction & MOVE_UP) {
		p->y_incr=-1;
		p->x_incr=0;
	}
	
	p->x += p->x_incr;
	p->y += p->y_incr;
	
	if (point(p->x, p->y)) return (0);
	plot (p->x, p->y);
	
	p->direction=joystick(p->joystick);
		
	for (x=0; x<SPEED; x++) {};
	return (1);
}


int play_game() {
	while (1) {
		if	(move_snake(p1)==0) {
	#ifdef PSG
			psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
	#endif
			crash(p1->x - p1->x_incr, p1->y - p1->y_incr);
			return(1);
		}
		
	#ifdef PSG
		psg_tone(1, psgT(p1->x+p1->y+10*(15+2*p1->x_incr+p1->y_incr)));
	#endif

		if	(move_snake(p2)==0) {
	#ifdef PSG
			psg_envelope(envD, psgT(10), chanAll); // set a fading volume envelope on all channels
	#endif
			crash(p2->x - p2->x_incr, p2->y - p2->y_incr);
			return(2);
		}
		
	#ifdef PSG
		psg_tone(2, psgT(p2->x+p2->y+12*(15+2*p2->x_incr+p2->y_incr)));
	#endif
	
	}
}


main()
{


#ifdef JOYSTICK_DIALOG

#ifdef TEXTSWAP
hrg_off();
#endif

  printf("%c\nLeft player controller:\n\n",12);

  for (x=0 ; x!=GAME_DEVICES; x++)
      printf("%u - %s\n",x+1,joystick_type[x]);
        
  p1.joystick=0;
  while ((p1.joystick<1) || (p1.joystick>GAME_DEVICES))
      p1.joystick=getk()-48;
 
  printf("%c\nLeft player controller:\n\n",12);

  for (x=0 ; x!=GAME_DEVICES; x++)
      printf("%u - %s\n",x+1,joystick_type[x]);
        
  p2.joystick=0;
  while ((p2.joystick<1) || (p2.joystick>GAME_DEVICES))
      p2.joystick=getk()-48;

#ifdef TEXTSWAP
hrg_on();
#endif
  
#else
	
	p1.joystick=1;
	p2.joystick=2;

#endif


	while (1) {
		clg();
		
		#ifdef PSG
		psg_init();
		psg_volume(1,10);
		psg_volume(2,10);
		#endif
		
		for (x=0; x<=getmaxx(); x++) {
			plot(x,0);  plot(x,getmaxy());
		}
		for (y=0; y<=getmaxy(); y++) {
			plot(0,y);  plot(getmaxx(),y);
		}
		
		p1.x=getmaxx()/5; p1.y=getmaxy()/5;	
		p1.direction=MOVE_LEFT;
		p1.x_incr=-1;
		p1.y_incr=0;
		
		p2.x=getmaxx()-getmaxx()/5; p2.y=getmaxy()-getmaxy()/5;
		p2.direction=MOVE_RIGHT;	
		p2.x_incr=1;
		p2.y_incr=0;

		play_game();
	}
				
}

