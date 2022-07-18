/*
	Coloured lib3d demo - multi color 3d cosine wave

	build with:   zcc +zx -lndos -lm -create-app ccoswave.c

	Build and link with alternative floating point libraries:
	zcc +zx -lndos -O2 -lm ccoswave.c -o ccoswave -create-app
	zcc +zx -lndos -O2 -lm48 ccoswave.c -o ccoswave48 -create-app
	zcc +zx -lndos -O2 --math32 ccoswave.c -o ccoswave32 -create-app
	zcc +zx -lndos -O2 --math16 ccoswave.c -o ccoswave16 -create-app

	stefano
*/

#include <graphics.h>
#include <stdio.h>
#include <math.h>

#include <zxlowgfx.h>

#ifdef __MATH_MATH16
    #define FLOAT       _Float16
    #define SIN         sinf16
    #define COS         cosf16
#else
    #define FLOAT       float
    #define SIN         sin
    #define COS         cos
#endif

int main()
{
FLOAT x,y;
char z,buf;
	cclg(0);	// init pseudo-graphics pattern

	for (x=-3.0; x<0.0; x+=0.06)
	{
		buf=100;
		for (y=-3.0; y<2.0; y+=0.20)
		{
			z = (char) (35.0 - (6.0 * (y + 3.0) + ( 6.0 * COS (x*x + y*y) )));
			if (buf>z)
			{
				buf = z;
				// coloured "rings"
				//cplot ( (char) (9.0 * (x+3.0)), (char) z, (4.0 +(COS (x*x + y*y) * 2.0)));

				// this colouring option has a phase shift and evidences of the "waves"
				cplot ( (char) (9.0 * (x+3.0)), (char) z, (3.0 +(SIN (x*x + y*y) * 2.0)));
			}
		}
	}
	
	while (getk() != 13) {};
}

