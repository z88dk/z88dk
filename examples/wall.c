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
 *
 *  Build options
 *  ===========
 *  -DSOUND      sound effects
 *  -DBORDERS    draw the wall borders
 *  -DLOMEM      minimalistic mode to save memory
 *  -DBANNERS    (where available) big top score display
 * 
 *  Values for 'spritesize' need roughly for following resolution table:
 *	16: 512x186 (vert. sprite size is 8)
 *	10: 320x186
 *	8: 256x186
 *	4: 128x94
 *	3: 96x72
 *	2: 64x48    spritesizeh=3: 64x72
 *
 *
 *
 *  Build and RUN hints
 *  ===================
 *
 *  ZX Spectrum 16K (non-joystick mode saves more memory)
 *     zcc +zx -lndos -create-app -DJOYSTICK -Dspritesize=8 -DSOUND -DCLOCK -zorg=24600 -O3 wall.c
 *
 *  ZX Spectrum 48K
 *     zcc +zx -lndos -create-app -DJOYSTICK -DBANNERS -Dspritesize=8 -DSOUND -DCLOCK -zorg=24600 -O3 wall.c
 *
 *  Lambda 8300
 *     zcc +lambda -create-app -Dspritesize=2 wall.c
 *
 *  ZX81
 *     zcc +zx81 -create-app -Dspritesize=2 -DBORDERS wall.c
 *
 *  ZX81 UDG (programmable characters board is required)
 *     zcc +zx81 -clib=udg -create-app -Dspritesize=2 -Dspritesizeh=3 wall.c
 *
 *  ZX81 WRX (Wilf Rigter's High Resolution mod on RamPack or RAM addressing lines)
 *     zcc +zx81 -subtype=wrx -clib=wrx -create-app -Dspritesize=8 -DBANNERS -O3 wall.c
 *
 *  ZX81 CHROMA-81 (the newest zx81 expansion, color attribute mode)
 *     zcc +zx81 -subtype=chroma -clib=chroma -create-app -Dspritesize=8 -DBANNERS -DSPECTRUM -O3 wall.c
 *
 *  ZX81 ARX (Andy Rea's High Resolution trick based on extra RAM over ROM addresses, could work with few programmable characters boards)
 *     zcc +zx81 -subtype=arx -clib=arx -create-app -Dspritesize=8 -DBANNERS -O3 wall.c
 *
 *  ZX81 + Memotech HRG board (16K or more)
 *     zcc +zx81 -clib=mt -create-app -Dspritesize=7 -DBANNERS -O3 wall.c
 *
 *  Jupiter ACE
 *     zcc +ace -create-app -Dspritesize=2 -Dspritesizeh=3 wall.c
 *     0 0 bload a.bin
 *
 *  Mattel Aquarius
 *     zcc +aquarius -create-app -Dspritesize=2 -Dspritesizeh=3 -DSOUND wall.c
 *     CLOAD   (play _a.caq)
 *     RUN     (play a.caq)
 *
 *  ABC80 (Intel HEX for the abc80 simulator)
 *     zcc +abc80 -subtype=hex -create-app -zorg=20000 -owall -Dspritesize=2 -Dspritesizeh=3 wall.c
 *     A=CALL(20000)
 *
 *  ABC80 (BAS & BAC formats)
 *     zcc +abc80 -create-app -owall -Dspritesize=2 -Dspritesizeh=3 wall.c
 *     LOAD WALL
 *
 *  MSX, Spectravideo SVI
 *     zcc +[msx/svi] -create-app -DJOYSTICK -Dspritesize=8 -DSOUND -DBANNERS wall.c
 *     BLOAD “CAS:”,R
 *
 *  SEGA SC-3000
 *     zcc +sc3000 -create-app -Dspritesize=8 -DBANNERS wall.c
 *     (insert the BASIC cartridge, then..)  LOAD
 *
 *  Memotech MTX 500  (use POKE 64122,0 or compile with "-startup=2" for the MTX 512)
 *     zcc +mtx -create-app -Dspritesize=8 -DJOYSTICK -DBANNERS wall.c
 *     LOAD "A"
 *
 *  Tatung Einstein
 *     zcc +cpm -DEINSTEIN -leinstein -oWALL -create-app -Dspritesize=8 -DJOYSTICK -DBANNERS wall.c
 *     (transfer WALL.COM on a disk image, i.e. using 'EDIP')
 *
 *  Amstrad CPC
 *     zcc +cpc -subtype=wav -lndos -create-app -Dspritesize=8 -DJOYSTICK -DBANNERS wall.c
 *
 *  Robotron KC85/1, KC/87 (Joystick optionally available)
 *     zcc +z9001 -lgfx9001krt -create-app -DSOUND -DBANNERS -Dspritesize=10 -Dspritesizeh=8 wall.c
 *
 *  Robotron KC85/2 .. KC85/5
 *     zcc +kc -create-app -DBANNERS -Dspritesize=10 -Dspritesizeh=8 wall.c
 *
 *  Commodore 128
 *     zcc +c128 -lgfx128hr -create-app -DSOUND -DBANNERS  -Dspritesize=16 -DJOYSTICK -Dspritesizeh=8 wall.c
 *
 *  Timex TS2068
 *     zcc +ts2068 -create-app -DSOUND -DBANNERS -DJOYSTICK -Dspritesize=16 -Dspritesizeh=8 wall.c
 *
 * * * * * * *
 *
 *      $Id: wall.c,v 1.13 2016-11-11 07:55:37 stefano Exp $
 *
 * * * * * * *
 *
 *
*/

#ifdef SPECTRUM
#ifdef ZX81
#pragma output hrgpage = 36096
#endif
#endif

#include <stdio.h>
#include <stdlib.h>
#include <games.h>
#include <stdlib.h>
#include <graphics.h>
#include <time.h>

#ifdef LAMBDA
#include <zx81.h>
#endif

#ifdef SPECTRUM
#ifdef ZX81
#include <zx81.h>
#else
#include <spectrum.h>
#endif
#endif

#if defined(MSX) || defined(SVI) || defined(SC3000) || defined(MTX) || defined(EINSTEIN)
#include <msx.h>
#include "msx/gfx.h"
#endif

#ifdef SOUND
#include <sound.h>
#endif


#ifndef spritesize
#define spritesize 4
#endif
#ifndef spritesizeh
#define spritesizeh spritesize
#endif

#include "wallg.h"

int stick,t,tt;
int m,n,p;
int u,v,a,w,r,g;
int c,b;
int i,k;
int speed;

#ifndef LOMEM
char scoretxt[7];
#ifdef BANNERS
int temp;
#endif
#endif

#if defined(MSX) || defined(SVI) || defined(SC3000) || defined(MTX) || defined(EINSTEIN)
void set_attr (int x, int y, int attr) {
		for (k=0; k<8; k++)
			vpoke(MODE2_ATTR + (256*x) + (8*y) + k, attr);
}
#endif

void do_delay () {
		for (k=0; k<speed; k++) {}
}

int hit_brick() {
#if (spritesize == 2)
	if (m>=20) return (0);
#endif
	return ((point(n*spritesize,(m+1)*spritesizeh-1)) && (point((n+1)*spritesize-1,(m+1)*spritesizeh-1)));
}

void hit_border() {
#ifdef SOUND
		bit_synth(15, 35, 34, 33, 32);
#endif

#ifdef SPECTRUM
#if (spritesize == 8)
zx_border (INK_CYAN);
#endif
#endif

#if defined(MSX) || defined(SVI) || defined(SC3000) || defined(MTX)
#if (spritesize == 8)
msx_color(WHITE, BLACK, CYAN);
#endif
#endif

#ifdef BORDERS
		/* draw/refresh borders */
		draw(0,0,32*spritesize-1,0);
		draw(0,0,0,21*spritesizeh);
		draw(32*spritesize-1,0,32*spritesize-1,21*spritesizeh);
#endif
}


void destroy_brick() {
	t = t+13-m;
	b = abs(m-n);

	putsprite(spr_and,(n*spritesize),(m*spritesizeh),blank);
	#ifdef SPECTRUM
	#if (spritesize == 8)
	#ifdef ZX81
		*zx_cyx2aaddr(m,n) = 112;
	#else
		*zx_cyx2aaddr(m,n) = 56;
	#endif
	#endif
	#endif
	
	#ifdef LAMBDA
		*zx_cyx2aaddr(m,n) = 112;
	#endif
	
	#if defined(MSX) || defined(SVI) || defined(SC3000) || defined(MTX) || defined(EINSTEIN)
	#if (spritesize == 8)
		set_attr (m,n,0x1f);
	#endif
	#endif


	if ((b&1) && (n>0)) {
		putsprite(spr_and,((n-1)*spritesize),(m*spritesizeh),blank);
	#ifdef SPECTRUM
	#if (spritesize == 8)
	#ifdef ZX81
		*zx_cyx2aaddr(m,n-1) = 112;
	#else
		*zx_cyx2aaddr(m,n-1) = 56;
	#endif
	#endif
	#endif
	
	#ifdef LAMBDA
		*zx_cyx2aaddr(m,n-1) = 112;
	#endif
	
	#if defined(MSX) || defined(SVI) || defined(SC3000) || defined(MTX) || defined(EINSTEIN)
	#if (spritesize == 8)
		set_attr (m,n-1,0x1F);
	#endif
	#endif
	}

	if ((!(b&1)) && (n<31))  {
		putsprite(spr_and,((n+1)*spritesize),(m*spritesizeh),blank);
	#ifdef SPECTRUM
	#if (spritesize == 8)
	#ifdef ZX81
		*zx_cyx2aaddr(m,n+1) = 112;
	#else
		*zx_cyx2aaddr(m,n+1) = 56;
	#endif
	#endif
	#endif
	
	#ifdef LAMBDA
		*zx_cyx2aaddr(m,n+1) = 112;
	#endif
	
	#if defined(MSX) || defined(SVI) || defined(SC3000) || defined(MTX) || defined(EINSTEIN)
	#if (spritesize == 8)
		set_attr (m,n+1,0x1F);
	#endif
	#endif
	}


	#ifdef SOUND
		bit_synth(10, 55, 54, 53, 52);
	#endif

	
#ifndef LOMEM
	sprintf (scoretxt,"%05u",tt*1000+t);

	for (i=0; i<5; i++) {
	  putsprite (spr_and, (2+i)*5, 23*spritesizeh-3, numblank);
	  putsprite (spr_or, (2+i)*5, 23*spritesizeh-3, &numbers[(scoretxt[i]-48)*7]);
	}
#endif
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

					/* A new trick to shake the ball and make possible
					   to hit all the bricks with a single ball */
					if (n>30) n--;

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

					/* A new trick to shake the ball and make possible
					   to hit all the bricks with a single ball */
					if (n<1) n++;

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
#if (spritesize == 2)
		putsprite(spr_and,(a*spritesize),(21*spritesizeh)-1,paddle);
		a--;
		putsprite(spr_or,(a*spritesize),(21*spritesizeh)-1,paddle);
#else
		putsprite(spr_and,(a*spritesize),(21*spritesizeh),paddle);
		a--;
		putsprite(spr_or,(a*spritesize),(21*spritesizeh),paddle);
#endif
	}
}

void move_right() {
	if (a<29) {
#if (spritesize == 2)
		putsprite(spr_and,(a*spritesize),(21*spritesizeh)-1,paddle);
		a++;
		putsprite(spr_or,(a*spritesize),(21*spritesizeh)-1,paddle);
#else
		putsprite(spr_and,(a*spritesize),(21*spritesizeh),paddle);
		a++;
		putsprite(spr_or,(a*spritesize),(21*spritesizeh),paddle);
#endif
	}
}




 /****  MAIN PROGRAM  ****/


void main()
{
restart:

#ifdef JOYSTICK
	hit_border();
#ifndef LOMEM
#if defined(MSX) || defined(SVI) || defined(SC3000) || defined(EINSTEIN)
	msx_text();
#endif

#ifdef SPECTRUM
#ifdef ZX81
	hrg_off();
	zx_colour(112);
#endif
#endif

	printf("%c",12);
	  printf("\n  CHOOSE YOUR JOYSTICK INTERFACE\n\n");
	for (k=0 ; k!=GAME_DEVICES; k++)
	  printf("    %u - %s\n\n",k+1,joystick_type[k]);

	stick=0;
	while ((stick<1) || (stick>GAME_DEVICES)) {
	  stick=getk()-48;
	  }
#else
	stick=1;
#endif
#endif

#ifdef SPECTRUM
#ifdef ZX81
	hrg_on();
	zx_colour(112);
#endif
#endif


#ifdef CLOCK
    srand(clock());
#endif
	tt=-1;

#ifdef ZX81
#if (spritesize == 2)
	speed=500;
#else
	speed=300;
#endif
#else
#ifdef C128
#else
	speed=300;
#endif
#endif

start_level:
#ifdef ZX81
	speed-=100;
#else
	speed-=200;
#endif

	tt++; t=0; p=1;
	clg();
	hit_border();

#ifdef LAMBDA
	zx_border (INK_CYAN);
	zx_colour(112);
#endif


  for (m=1; m<=4; m+=2)
	for (n=0; n<=30; n+=2) {
		putsprite(spr_or,(n*spritesize),((m+3)*spritesizeh),brick_l);
		putsprite(spr_or,((n+1)*spritesize),((m+3)*spritesizeh),brick_r);
		putsprite(spr_or,(n*spritesize),((m+4)*spritesizeh),brick_r);
		putsprite(spr_or,((n+1)*spritesize),((m+4)*spritesizeh),brick_l);
	#if (spritesize == 8)
	#ifdef SPECTRUM
	#ifdef ZX81
		*zx_cyx2aaddr(m+3,n) = m<<4;
		*zx_cyx2aaddr(m+3,n+1) = m<<4;
		*zx_cyx2aaddr(m+4,n) = (m+1)<<4;
		*zx_cyx2aaddr(m+4,n+1) = (m+1)<<4;
	#else
		*zx_cyx2aaddr(m+3,n) = m<<3;
		*zx_cyx2aaddr(m+3,n+1) = m<<3;
		*zx_cyx2aaddr(m+4,n) = (m+1)<<3;
		*zx_cyx2aaddr(m+4,n+1) = (m+1)<<3;
	#endif
	#endif
	#endif
	
	#ifdef LAMBDA
		*zx_cyx2aaddr(m+3,n) = m<<4;
		*zx_cyx2aaddr(m+3,n+1) = m<<4;
		*zx_cyx2aaddr(m+4,n) = (m+1)<<4;
		*zx_cyx2aaddr(m+4,n+1) = (m+1)<<4;
	#endif
	
	#if defined(MSX) || defined(SVI) || defined(SC3000) || defined(MTX) || defined(EINSTEIN)
	#if (spritesize == 8)
		set_attr(m+3,n,((m+1)<<1)|0x10);
		set_attr(m+3,n+1,((m+1)<<1)|0x10);
		set_attr(m+4,n,(m<<1)|0x10);
		set_attr(m+4,n+1,(m<<1)|0x10);
	#endif
	#endif
	}
  for (n=0; n<=30; n+=2) {
		putsprite(spr_or,(n*spritesize),((m+3)*spritesizeh),brick_l);
		putsprite(spr_or,((n+1)*spritesize),((m+3)*spritesizeh),brick_r);
	#if (spritesize == 8)
	#ifdef SPECTRUM
	#ifdef ZX81
		*zx_cyx2aaddr(m+3,n) = 6<<4;
		*zx_cyx2aaddr(m+3,n+1) = 6<<4;
	#else
		*zx_cyx2aaddr(m+3,n) = 6<<3;
		*zx_cyx2aaddr(m+3,n+1) = 6<<3;
	#endif
	#endif
	#endif
	
	#ifdef LAMBDA
		*zx_cyx2aaddr(m+3,n) = 6<<4;
		*zx_cyx2aaddr(m+3,n+1) = 6<<4;
	#endif
	
	#if defined(MSX) || defined(SVI) || defined(SC3000) || defined(MTX) || defined(EINSTEIN)
	#if (spritesize == 8)
		set_attr(m+3,n,LIGHT_YELLOW|0x10);
		set_attr(m+3,n+1,LIGHT_YELLOW|0x10);
	#endif
	#endif
	}
	
	u=0; v=0; a=14; t=0; w=0;

  for (r=0; r<=6; r++) {
			m=10;  n=8+rand()%15;
			p=0; a=13;

#if (spritesize == 2)
	putsprite(spr_or,(a*spritesize),(21*spritesizeh)-1,paddle);
#else
	putsprite(spr_or,(a*spritesize),(21*spritesizeh),paddle);
#endif

#ifndef LOMEM
	for (i=0; i<=6; i++) {
	  putsprite (spr_and, (24+i)*spritesize, 23*spritesizeh, ball);
	  if (i>r)
		putsprite (spr_or, (24+i)*spritesize, 23*spritesizeh, ball);
	}
#endif

		g=200;

		/* Let's show where the ball stars before the dance begins */
		putsprite(spr_or,(n*spritesize),(m*spritesizeh),ball);

		hit_border();
#ifdef SOUND
		for (i=1; i<14; i++) {
			bit_synth(4, 199+i, 200+i, 239+i, 240+i);
			putsprite(spr_and,(n*spritesize),(m*spritesizeh),ball);
		}
		bit_synth(9, 255, 254, 253, 252);
#endif

		putsprite(spr_and,(n*spritesize),(m*spritesizeh),ball);

		while (m <= 20) {

			/* delay */
			do_delay();

			move_ball();

			/* total score count is 574 */
			if (t>=573) goto start_level;

			if (u==20)
				putsprite(spr_and,(v*spritesize),(u*spritesizeh),bounce);
			else
				putsprite(spr_and,(v*spritesize),(u*spritesizeh),ball);

			/* Intermediate step to move the ball smoothly */
			putsprite(spr_xor,(((n+v)*spritesize)>>1),(((m+u)*spritesizeh)>>1),ball);
			do_delay();
			putsprite(spr_xor,(((n+v)*spritesize)>>1),(((m+u)*spritesizeh)>>1),ball);

			u=m; v=n;
			if (m==20)
				putsprite(spr_or,(n*spritesize),(m*spritesizeh),bounce);
			else
				putsprite(spr_or,(n*spritesize),(m*spritesizeh),ball);

/*
	#ifdef SOUND
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
					break;
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

#if (spritesize == 2)
	  putsprite(spr_and,(a*spritesize),(21*spritesizeh)-1,paddle);
#else
	  putsprite(spr_and,(a*spritesize),(21*spritesizeh),paddle);
#endif
  }


#ifdef ZX81
#if (spritesize == 2)
  #asm
			ld	a,$1e
			ld	i,a
  #endasm
#endif
#endif

#ifndef LOMEM
#ifdef BANNERS
  putsprite(spr_or,40,(12*spritesizeh),scorebanner);
  sprintf (scoretxt,"%05u",tt*1000+t);

  k=0;
  for (i=0; i<5; i++) {
    putsprite (spr_or, 140+i+k, 12*spritesizeh+7, &bigdigit[(scoretxt[i]-48)*38]);
	if (scoretxt[i]=='1')
		k+=5;
	else
		k+=14;
  }

#else
  printf("%c\n\n Score: %u ",12,tt*1000+t);
#endif
#endif

/*  return (tt*1000+t); */
#ifdef SOUND
bit_fx2(5);
#endif
while (getk()) {}
while (!getk()) {}

goto restart;

}

