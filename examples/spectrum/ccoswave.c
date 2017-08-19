/*
	Coloured lib3d demo - multi color 3d cosine wave

	build with:   zcc +zx -lndos -lm -create-app ccoswave.c

	$id:$
*/

#include <graphics.h>
#include <stdio.h>
#include <math.h>

#include <zxlowgfx.h>

main()
{
float x,y;
char z,buf;
	cclg(0);	// init pseudo-graphics pattern

	for (x=-3.0; x<3.0; x=x+0.06)
	{
		buf=100;
		for (y=-3.0; y<2.0; y=y+0.2)
		{
			z = (char) 35.0 - (6.0 * (y + 3.0) + ( 6.0 * cos (x*x + y*y) ));
			if (buf>z)
			{
				buf = z;
				// coloured "rings"
				//cplot ( (char) (9.0 * (x+3.0)), (char) z, (4.0 +(cos (x*x + y*y) * 2.0)));

				// this colouring option has a phase shift and evidences of the "waves"
				cplot ( (char) (9.0 * (x+3.0)), (char) z, (3.0 +(sin (x*x + y*y) * 2.0)));
			}
		}
	}
	
	while (getk() != 13) {};
}

