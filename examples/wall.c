/* 
 * * * * * * *
 *
 *  This game was originally published on the ZX Spectrum 'Horizons' demo tape
 *  Converted to 'C' by Stefano Bodrato, September 2014
 *  It is still a little buggy, but it works !
 *
 *  Non-Joystick mode keys:
 *	  1:fast-left
 *	  2:left
 *	  9:right
 *	  0:fast-right
 *
 *  Values for 'spritesize' need roughly for following resolution table:
 *	8: 256x186
 *  4: 128x94
 *  3: 96x72
 *  2: 64x52
 *
 *  Build hints
 *  ===========
 *
 *  ZX Spectrum 16K
 *     zcc +zx -lndos -create-app -DJOYSTICK -Dspritesize=8 -DSOUND -zorg=24600 -O3 wall.c
 *
 *  ZX81
 *     zcc +zx81 -create-app -Dspritesize=2 wall.c
 *
 *  ZX81 WRX
 *     zcc +zx81 -startup=wrx -subtype=wrx -clib=wrx -create-app -Dspritesize=8 -O3 wall.c
 *
 * * * * * * *
 *
 *      wall.c
 *
 * * * * * * *
 *
 *
 
 */

#include <stdio.h>
#include <stdlib.h>
#include <games.h>
#include <stdlib.h>
#include <graphics.h>
#ifdef SPECTRUM
#include <spectrum.h>
#endif

#ifdef SOUND
#include <sound.h>
#endif


#ifndef spritesize
#define spritesize 4
#endif


#include "wallg.h"

int stick, t,tt;
int m,n,p;
int u, v, a, w, r, g;
int c,b;
int i,k;
int speed;
char scoretxt[7];


void do_delay () {
		for (k=0; k<speed; k++) {}
}

int hit_brick() {
//	if (m==0) return (0);
	return ((point(n*spritesize,(m+1)*spritesize-1)) && (point((n+1)*spritesize-1,(m+1)*spritesize-1)));
}

void hit_border() {
#ifdef SOUND
		bit_synth(15, 35, 34, 33, 32);
#endif

#ifdef SPECTRUM
#if (spritesize == 8)
zx_border (5);
#endif
#endif

#ifdef BORDERS
		/* draw/refresh borders */
		draw(0,0,32*spritesize-1,0);
		draw(0,0,0,21*spritesize);
		draw(32*spritesize-1,0,32*spritesize-1,21*spritesize);
#endif
}


void destroy_brick() {
	//t = t+10-c/8;
	t = t+13-m;
	b = abs(m-n);

	putsprite(spr_and,(n*spritesize),(m*spritesize),blank);
	#ifdef SPECTRUM
	#if (spritesize == 8)
		*zx_cyx2aaddr(m,n) = 56;
	#endif
	#endif
	if ((b&1) && (n>0)) {
		putsprite(spr_and,((n-1)*spritesize),(m*spritesize),blank);
	#ifdef SPECTRUM
	#if (spritesize == 8)
		*zx_cyx2aaddr(m,n-1) = 56;
	#endif
	#endif
	}  else if (n<31)  {
		putsprite(spr_and,((n+1)*spritesize),(m*spritesize),blank);
	#ifdef SPECTRUM
	#if (spritesize == 8)
		*zx_cyx2aaddr(m,n+1) = 56;
	#endif
	#endif
	}


	#ifdef SOUND
		bit_synth(10, 55, 54, 53, 52);
	#endif

	
	sprintf (scoretxt,"%05u",tt*1000+t);

	for (i=0; i<5; i++) {
	  putsprite (spr_and, (2+i)*5, 23*spritesize-3, numblank);
	  putsprite (spr_or, (2+i)*5, 23*spritesize-3, &numbers[(scoretxt[i]-48)*7]);
	}
}



void move_ball() {

		switch (g) {
			case 100:
			l_100:
				if (m<20) goto l_106;
				p=0; w=0;
				if ((n==(a+1)||(n==(a+2)))) {
					g=120;  goto l_120;
				}
				if (n==a) {
					g=180;  goto l_180;
				}
				if (n==(a-1)) {
					g=140;  goto l_140;
				}
			l_106:
				if (n>30) {
					hit_border();
					g=160;  goto l_160;
				}
				m++; n++;
				if (hit_brick()) {
					destroy_brick();
					if ((p==0) || (w==1))
						g=120;
				}
				break;

			case 120:
			l_120:
#ifdef SOUND
				if (m==20)
					bit_synth(20, 25, 24, 23, 22);
#endif
				if (n>30) {
					hit_border();
					g=140;  goto l_140;
				}
				if (m<1) {
					hit_border();
					w=1;
					g=100;  goto l_100;
				}
				m--; n++;
				if (hit_brick()) {
					destroy_brick();
					p=1;
					g=100+40*w;
				}
				break;

			case 140:
			l_140:
#ifdef SOUND
				if (m==20)
					bit_synth(20, 25, 24, 23, 22);
#endif
				if (m<1) {
					hit_border();
					w=1;
					g=160;  goto l_160;
				}
				if (n<1) {
					hit_border();
					g=120;  goto l_120;
				}
				m--;  n--;
				if (hit_brick()) {
					destroy_brick();
					p=1;
					g=160-40*w;
				}
				break;

			case 160:
			l_160:
				if (m<20)  goto l_166;
				p=0; w=0;
				if (n==(a+3)) {
					g=120;  goto l_120;
				}
				if (n==(a+2)) {
					g=180;  goto l_180;
				}
				if ((n==a)||(n==(a+1))) {
					g=140;  goto l_140;
				}
			l_166:
				if (n<1) {
					hit_border();
					g=100;  goto l_100;
				}
				m++;  n--;
				if (hit_brick()) {
					destroy_brick();
					if ((p==0) || (w==1))
						g=140;
				}
				break;

			case 180:
			l_180:
#ifdef SOUND
				if (m==20)
					bit_synth(20, 25, 24, 23, 22);
#endif
				if (m<1) {
					hit_border();
					g=200;  goto l_212;
				}
			l_190:
				m--;
				if (hit_brick()) {
					destroy_brick();
					g=200;
				}
				break;

			case 200:
				if (m<20)
					goto l_212;
				p=0;  w=0;
				if (n==(a+2)) {
					g=120;  goto l_120;
				}
				if (n==a+1) {
					if (rand()&1) {
						g=120; goto l_120;
					} else {
						g=140; goto l_140;
					}
				}
				if (n==a) {
						g=140; goto l_140;
				}
				l_212:
				m++;
				break;
		}
}




void move_left() {
	if (a>0) {
		putsprite(spr_xor,(a*spritesize),(21*spritesize),paddle);
		a--;
		putsprite(spr_or,(a*spritesize),(21*spritesize),paddle);
	}
}

void move_right() {
	if (a<29) {
		putsprite(spr_xor,(a*spritesize),(21*spritesize),paddle);
		a++;
		putsprite(spr_or,(a*spritesize),(21*spritesize),paddle);
	}
}




 /****  MAIN PROGRAM  ****/


void main()
{

#ifdef JOYSTICK
	printf("%c",12);

	for (k=0 ; k!=GAME_DEVICES; k++)
	  printf("%u - %s\n",k+1,joystick_type[k]);
		
	stick=0;
	while ((stick<1) || (stick>GAME_DEVICES))
	  stick=getk()-48;
#else
	stick=1;
#endif

	tt=-1;

#ifdef ZX81
#if (spritesize == 2)
	speed=500;
#else
	speed=300;
#endif
#else
	speed=1000;
#endif

start_level:
	speed-=200;
	tt++; t=0; p=1;
	clg();

  for (m=1; m<=4; m+=2)
	for (n=0; n<=30; n+=2) {
		putsprite(spr_or,(n*spritesize),((m+3)*spritesize),brick_l);
		putsprite(spr_or,((n+1)*spritesize),((m+3)*spritesize),brick_r);
		putsprite(spr_or,(n*spritesize),((m+4)*spritesize),brick_r);
		putsprite(spr_or,((n+1)*spritesize),((m+4)*spritesize),brick_l);
	#ifdef SPECTRUM
	#if (spritesize == 8)
		*zx_cyx2aaddr(m+3,n) = m<<3;
		*zx_cyx2aaddr(m+3,n+1) = m<<3;
		*zx_cyx2aaddr(m+4,n) = (m+1)<<3;
		*zx_cyx2aaddr(m+4,n+1) = (m+1)<<3;
	#endif
	#endif
	}
  for (n=0; n<=30; n+=2) {
		putsprite(spr_or,(n*spritesize),((m+3)*spritesize),brick_l);
		putsprite(spr_or,((n+1)*spritesize),((m+3)*spritesize),brick_r);
	#ifdef SPECTRUM
	#if (spritesize == 8)
		*zx_cyx2aaddr(m+3,n) = 6<<3;
		*zx_cyx2aaddr(m+3,n+1) = 6<<3;
	#endif
	#endif
	}
	
	u=0; v=0; a=14; t=0; w=0;

  for (r=0; r<=6; r++) {
			m=10;  n=8+(char)rand()&15;//+(rand()%14);
			p=0; a=13;
		
	putsprite(spr_or,(a*spritesize),(21*spritesize),paddle);

	for (i=0; i<=6; i++) {
	  putsprite (spr_and, (24+i)*spritesize, 23*spritesize, ball);
	  if (i>r)
		putsprite (spr_or, (24+i)*spritesize, 23*spritesize, ball);
	}

		g=200;

		hit_border();
#ifdef SOUND
		for (i=1; i<14; i++)
			bit_synth(4, 199+i, 200+i, 239+i, 240+i);
		bit_synth(9, 255, 254, 253, 252);
#endif

		while (m <= 20) {

		/* delay */
		do_delay();

			move_ball();

			/* total score count is 574 */
			if (t>=573) goto start_level;

			if (u==20)
				putsprite(spr_and,(v*spritesize),(u*spritesize),bounce);
			else
				putsprite(spr_and,(v*spritesize),(u*spritesize),ball);

		/* Intermediate step to move the ball smoothly */
			putsprite(spr_xor,(((n+v)*spritesize)>>1),(((m+u)*spritesize)>>1),ball);

		/* delay */
		do_delay();

		/* Intermediate step to move the ball smoothly */
			putsprite(spr_xor,(((n+v)*spritesize)>>1),(((m+u)*spritesize)>>1),ball);

			u=m; v=n;
			if (m==20)
				putsprite(spr_or,(n*spritesize),(m*spritesize),bounce);
			else
				putsprite(spr_or,(n*spritesize),(m*spritesize),ball);

/*
	#ifdef SOUND
//		bit_synth(4, 255, 254, 253, 252);
		bit_click();
	#endif
*/

#ifdef JOYSTICK
			if (joystick(stick) & MOVE_LEFT) {
				move_left();
				if (joystick(stick) & MOVE_FIRE)
					move_left();
			}
			if (joystick(stick) & MOVE_RIGHT) {
				move_right();
				if (joystick(stick) & MOVE_FIRE)
					move_right();
			}
#else
			k=getk();
			switch (k) {
				case '2':
					move_left();
					break
				case '1':
					move_left();
					move_left();
					break;
				case '9':
					move_right();
					break;
				case '0':
					move_right();
					move_right();
					break;
			}
#endif
		}
		/* ball is lost */
	//  printf("\nBall %u lost",r);
	  putsprite(spr_and,(a*spritesize),(21*spritesize),paddle);
	
  }
  printf("\n\n Score: %u ",tt*1000+t);

}

