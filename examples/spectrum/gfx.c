
/*
 * Graphics demo - not for the Spectrum only but tuned for a 256x192 resolution
 * Shows the capability of several graphics functions.
 * 
 * To build:
 * 	zcc +zx -lm -lndos -create-app gfx.c
 * -or-
 *	zcc +zx -lmzx -lndos -create-app gfx.c
 * The latter is optimized for size calling the Spectrum ROM,
 * but runs slower.
 * 
 * 
 * $Id: gfx.c,v 1.5 2009-10-02 10:17:18 stefano Exp $
 * 
 */

#include <graphics.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

struct window mine;     /* Window structure */
unsigned char stencil[192*2];

main()
{
        float  x;
        int     i,j,k,l;

	clg();

/* Draw a series of concentric circles in the centre of the screen 
 * these go off the screen but don't generate an error - very cool!
 */
        for (i=90 ; i>=0; i--)
        {
                circle(128,128,i,1);
                if (i < 25 ) i--;
                if (i < 55 ) i--;
                if (i < 75 ) i--;
        }

// Sort of 3d ball
		for (i=4;i>0;i--) {
			stencil_init(stencil);
			stencil_add_circle(80*3-i, 22+i, i*3+5, 1, stencil);
			stencil_render(stencil, 14-(i*2));
		}


	draw(0,0,255,47);

/* Draw a diamond - weak, but it demonstrates relative drawing! */

        plot(140,22);

        drawr(20,20);
        drawr(20,-20);
        drawr(-20,-20);
        drawr(-20,20);
        
        fill(148,24);
        
        for (i=0;i<12;i++) {
        // now a filled diamond via stencil
			stencil_init(stencil);
			stencil_add_side(10+i*8,50,30+i*8,30,stencil);
			stencil_add_side(30+i*8,30,50+i*8,50,stencil);
			stencil_add_side(50+i*8,50,30+i*8,70,stencil);
			stencil_add_side(10+i*8,50,30+i*8,70,stencil);
			stencil_render(stencil, i);
		}

/* Draw a sort of 3D cone, based on an ellipse */
		k=0;
        for (x=7.2 ; x>2.0; x=x-0.1)
        {
			i=170+(int)(sin(x)*50.0);
			j=160+(int)(cos(x)*20.0);
			stencil_init(stencil);
			
			if (k!=0) {
				stencil_add_side(170,60,k,l,stencil);
				stencil_add_side(170,60,i,j,stencil);
				stencil_add_side(i,j,k,l,stencil);
			}
			stencil_render(stencil, x*1.6);
			k=i;l=j;
        }
}

