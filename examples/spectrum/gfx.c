
#include <graphics.h>
#include <stdio.h>
#include <stdlib.h>

struct window mine;     /* Window structure */
unsigned char stencil[192*2];

main()
{
        int     j,i;

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
        
        // now a filled diamond via stencil
			stencil_init(stencil);
			stencil_add_side(stencil,10,50,30,30);
			stencil_add_side(stencil,30,30,50,50);
			stencil_add_side(stencil,50,50,30,70);
			stencil_add_side(stencil,10,50,30,70);
			stencil_render(stencil, 9);
		}

}

