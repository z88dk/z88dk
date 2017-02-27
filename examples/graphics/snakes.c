/*

	Z88DK base graphics libraries examples
	
	A classic 2 players game, the opponents must trap each other.
  by Stefano Bodrato, Feb 2017
	
	Build options:
	-DJOYSTICK_DIALOG	- let the players choose their controllers
	
	SPEED must be adjusted according to the CPU speed (e.g. must be around 500 on a ZX81)

*/

#include <graphics.h>
#include <games.h>
#ifdef JOYSTICK_DIALOG
#include <stdio.h>
#endif

#define SPEED 2500

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
			crash(p1->x - p1->x_incr, p1->y - p1->y_incr);
			return(1);
		}
		if	(move_snake(p2)==0) {
			crash(p2->x - p2->x_incr, p2->y - p2->y_incr);
			return(2);
		}
	}
}


main()
{

#ifdef JOYSTICK_DIALOG

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
  
#else
	
	p1.joystick=1;
	p2.joystick=2;

#endif


	while (1) {
		clg();
		
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

