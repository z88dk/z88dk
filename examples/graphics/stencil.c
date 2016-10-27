/*=========================================================================

Demonstration on how to use the 'stencil' object.

zcc +zx -vn -lndos -create-app -llib3d stencil.c -o stencil
	
$Id: stencil.c,v 1.3 2016-10-27 15:05:45 stefano Exp $

=========================================================================*/

#include <stdlib.h>
#include <graphics.h>
#include <lib3d.h>

	/* When the graphics library does not use the "wide" mode functions
	   the stencil object could be 50% smaller */
	
	unsigned char stencil[256*4];
int x,y,r,p;

main() {

	clg();

	// paint polygon or circle
for (;;) {

		// get a random position and size for the object
		x=rand()%getmaxx(); y=rand()%getmaxy(); r=rand()%(getmaxy()/2);
		// if it does not go out of screen, then paint it..
		if (((x-r)>0) && ((x+r)<getmaxx()) && ((y-r)>0) && ((y+r)<getmaxy())) {
			stencil_init(stencil);
			p=rand()%8;
			if (!p)
				stencil_add_circle(x, y, r, 1, stencil);
			else
				// rotate thepolygon by a random angle
				stencil_add_polygon(x, y, p+2, r, rand()%180, stencil);
			// fill object with a texture of a random brightness
			stencil_render(stencil, rand()%12);
		}
	}
}
