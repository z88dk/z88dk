/*=========================================================================

Box drawing test program

zcc +zx -lndos -create-app boxes.c
	
$Id: boxes.c $

=========================================================================*/

#include <graphics.h>
#include <stdlib.h>


int x, y, r1, r2, p;

void main()
{

    clg();

    // paint polygon or circle
    for (;;) {

        // get a random position and size for the object
        x = 1+ rand() % getmaxx();
        y = 1+ rand() % getmaxy();
        r1 = 1+ rand() % (getmaxx() / 2);
		r2 = 1+ rand() % (getmaxy() / 2);
		
        // if it does not go out of screen, then paint it..
        if ( ((x + r1) < getmaxx()) && ((y + r2) < getmaxy()) ) {
            
            p = rand() % 4;
			switch (p) {
			case 0:
				xorborder (x,y,r1,r2);
				break;
			case 1:
				undrawb (x,y,r1,r2);
				break;
			case 2:
				drawb (x,y,r1,r2);
				break;
			case 3:
				xordrawb (x,y,r1,r2);
				break;
			}
        }
    }
}
