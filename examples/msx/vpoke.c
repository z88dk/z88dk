/*
	Z88DK example for MSX style VDP support

	Example on:
	- how to convert a program from MSX C to Z88dk
	- MSX screen "mode 1" support on Spectravideo SVI
	- vpoke command for direct VDP access
	- differences between sdcc and z88dk (speed, parameter passing equivalences)
	
	$Id: vpoke.c $
	
	-- examples listed in increasing speed order --
	zcc +svi -lndos -create-app -O0 vpoke.c
	zcc +svi -lndos -create-app -O3 vpoke.c
	zcc +svi -lndos -create-app -compiler=sdcc vpoke.c
	
	zcc +msx -lndos -create-app vpoke.c
	zcc +msx -lndos -create-app -compiler=sdcc vpoke.c
*/

#include <stdio.h>
#include <video/tms99x8.h>


//#define T32NAM *((int *)0xf3bd)
#define T32NAM 0x1800

void myfill(char ch)
{
	int i, j, k;
	int ad = T32NAM - 1;
	int x = 32;
	int y = 23;

	for (i = 0; i <= 11; ++i) {
		for (j = 0; j < x; ++j) {
			vdp_vpoke(++ad, ch);
			for (k = 0; k < 1000; ++k);
		}
	    --x;
		for (j = 0; j < y; ++j) {
			vdp_vpoke(ad += 32, ch);
			for (k = 0; k < 1000; ++k);
		}
	    --y;
		for (j = 0; j < x; ++j) {
			vdp_vpoke(--ad, ch);
			for (k = 0; k < 1000; ++k);
		}
	    --x;
		for (j = 0; j < y; ++j) {
			vdp_vpoke(ad -= 32, ch);
			for (k = 0; k < 1000; ++k);
		}
	    --y;
	}
}

void main()
{
	int i;
	//ginit();
	vdp_color(15, 0, 0);
	//screen(1);
	vdp_set_mode(mode_1);
	myfill('?');
	myfill(' ');
	//screen(0);
	vdp_set_mode(mode_0);
}

