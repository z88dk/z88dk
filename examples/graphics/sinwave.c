
#include <graphics.h>
#include <stdio.h>
#include <math.h>

main()
{
float x,y;
char z,buf;
	//clg();

	for (x=-3.0; x<3.0; x=x+0.06)
	{
		buf=-100;
		for (y=-3.0; y<3.0; y=y+0.2)
		{
			z = (40 - (char) (5.0 * (y + 3.0) + ( 10.0 * sin ((float) (x*x + y*y)) )));
			if (buf>z)
			{
				buf = z;
				plot ( (char) (15.0 * (x+3.0)), (char) z);
			}
		}
	}
	
	while (getk() != 13) {};
}

