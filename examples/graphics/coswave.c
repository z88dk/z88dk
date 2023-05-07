/*

	Z88DK base graphics libraries examples
	Simple 3D math function drawing using the Z-buffer algorithm
	
	The picture size is automatically adapted to the target display size
	
	to build:  zcc +<target> <stdio options> -lm -create-app coswave.c
	or
	to build using math32:  zcc +<target> <stdio options> --math32 -create-app coswave.c
	
	Examples:
	  zcc +zx -lm -lndos -create-app coswave.c
	  zcc +aquarius -lm -create-app coswave.c
	
	stefano

*/

#include <graphics.h>
#include <stdio.h>
#include <math.h>

void main()
{

float x,y,incr,yenlarge;
int z,buf;

	clg();
	incr=2.0/(float)getmaxx();
	yenlarge=(float)getmaxy() / 6.0;

	for (x=-3.0; x<0; x=x+incr)
	{
		buf=getmaxy();
		for (y=-3.0; y<3.0; y=y+0.2)
		{
			z = (float)getmaxy() - (yenlarge * (y + 3.0) + yenlarge * (cos (x*x + y*y)) );

			if (buf>z)
			{
				buf = z;
				plot ( (int) ((float)getmaxx() / 6.0 * (x + 3.0)),  z);
				plot ( (int) ((float)getmaxx() / 6.0 * (3.0 - x)),  z);
			}
		}
	}
	
	while (getk() != '\n') {};
}

