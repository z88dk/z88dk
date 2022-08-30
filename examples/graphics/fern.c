
/*
 * fern.c  -*- C -*-
 * 

	to build:  zcc +<target> -lm -create-app fern.c
	or
	to build using math32:  zcc +<target> --math32 -create-app fern.c
	
	zcc +zx -lndos -create-app -lm fern.c
	zcc +ts2068 -pragma-define:CLIB_DEFAULT_SCREEN_MODE=6 -lm -create-app fern.c
	zcc +c128 -lgfx128hr -lm -create-app -DVERTICAL fern.c

 * 
 * Original program by Guido Gonzato, May 2015.
 * z88dk version by Stefano Bodrato, Jul 2022.
 *
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 * 
 */


#include <graphics.h>
#include <stdio.h>
#include <stdlib.h> // for random()
#include <math.h>
//#include <time.h>


  int midx, midy, scalex, scaley;
  int prob;
  int k;

  float x, y, xx, yy;
  float
    a[4] = {0.0, 0.85, 0.2, -0.15},
    b[4] = {0.0, 0.04, -0.26, 0.28},
    c[4] = {0.0, 0.04, 0.23, 0.26},
    d[4] = {0.16, 0.85, 0.22, 0.24},
/*  e[4] = {0.0, 0.0, 0.0, 0.0}, */
    f[4] = {0.0, 1.6, 1.6, 0.44};
/*  p[4] = {0.01, 0.85, 0.07, 0.07}; */


void main()
{

  k = 0;

  clg();

//srand (clock());


#ifdef VERTICAL
  midx = getmaxx () / 2;
  midy = getmaxy ();
  scalex = getmaxx () / 13;
  scaley = getmaxy () / 12;
#else
  scalex = getmaxx () / 12;
  scaley = getmaxy () / 11;
  midx = scalex/getmaxx ();
  midy = getmaxy () / 2;
#endif



  x = y = 0.0;
  
  while (getk() != 0) {}

  while (getk() == 0) {
    prob = 1 + rand() % 100;
    if (prob == 1)
      k = 0;
    if ( (prob > 1) && (prob < 87))
      k = 1;
    if ( (prob > 86) && (prob < 94))
      k = 2;
    if (prob > 93)
      k = 3;
    
    /* to use equal probability, just use:
     * k = random (5);
     */

    xx = a[k] * x + b[k] * y; /*  + e[k]; */
    yy = c[k] * x + d[k] * y + f[k];
    x = xx;
    y = yy;
	
#ifdef VERTICAL
	plot ((midx + scalex * x), (midy - scaley * y));
#else
	plot ((midx + scalex * y), (midy - scaley * x));
#endif

  }

}

