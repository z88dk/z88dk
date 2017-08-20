/*

	Z88DK base graphics libraries examples
	Simple 3D math function drawing using the Z-buffer algorithm
	
	The picture size is automatically adapted to the target display size
	
	to build:  zcc +<target> <stdio options> -lm -create-app sinwave.c
	
	Examples:
	  zcc +zx -lm -lndos -create-app sinwave.c
	  zcc +aquarius -lm -create-app sinwave.c
	
	$Id: coswave.c,v 1.4 2011-04-01 06:50:45 stefano Exp $

*/

#include <graphics.h>
#include <stdio.h>
#include <math.h>
#include <lib3d.h>

main()
{

float x,y,incr,yenlarge;
int z,buf;

	clg();
	incr=2.0/(float)getmaxx();
	yenlarge=(float)getmaxy() / 6.0;

	for (x=-3.0; x<0; x=x+incr)
	{
		buf=255;
		for (y=-3.0; y<3.0; y=y+0.2)
		{
			z = (unsigned char) (float)getmaxy() - (yenlarge * (y + 3.0) + yenlarge * (cos (x*x + y*y)) );

			if (buf>z)
			{
				buf = z;
				plot ( (int) ((float)getmaxx() / 6.0 * (x + 3.0)),  z);
				plot ( (int) ((float)getmaxx() / 6.0 * (3.0 - x)),  z);
			}
		}
	}
	
	while (getk() != 13) {};
}

