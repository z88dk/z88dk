
#include <graphics.h>
#include <stdio.h>
#include <stdlib.h>

struct window mine;     /* Window structure */

main()
{
        int     j,i;

	clg();

/* Draw a series of concentric circles in the centre of the screen 
 * these go off the screen but don't generate an error - very cool!
 */
        for (i=90 ; i!=0; i--)
        {
                circle(128,96,i,1);
                if (i < 25 ) i--;
        }


	draw(0,0,255,63);

/* Draw a diamond - weak, but it demonstrates relative drawing! */
        plot(200,32);

        drawr(10,10);
        drawr(10,-10);
        drawr(-10,-10);
        drawr(-10,10);
}

