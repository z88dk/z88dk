
/*
	Coloured mandelbrot demo
	
	to build:  zcc +<target> <stdio options> -lm -create-app cmandel.c
	or
	to build using math32:  zcc +<target> <stdio options> --math32 -create-app cmandel.c
	
	Examples:
	  zcc +zx -lm -lndos -create-app cmandel.c
	  zcc +aquarius -lm -create-app cmandel.c

*/


#include <math.h>
#include <stdio.h>
#include <graphics.h>

void main()
{
    float a, b, c, d, e, g, h, i, j;
    int x, y;
    int xmax, ymax;
    int k;
    float l, m, n, o, p;

    cclg();

    xmax = getmaxx();
    ymax = getmaxy();

    a = -2.0;
    b = 2.0;
    c = a;
    d = b;

    //a=-0.765; b=-0.7651;
    //c=-0.095; d=-0.0951;

    e = 4.0;

    g = (b - a) / (float)xmax;
    h = (d - c) / (float)ymax;

    for (y = ymax / 2; y >= 0; y--) {
        j = (float)y * h + c;
        for (x = xmax; x >= 0; x--) {
            i = (float)x * g + a;
            k = 0;
            l = 0.0;
            m = 0.0;
            n = 0.0;
            o = 0.0;
        l110:
            k++;
            if (k < 50) //Iterates
            {
                p = n - o + i;
                m = 2.0 * l * m + j;
                l = p;
                n = l * l;
                o = m * m;

                if ((n + o) < e)
                    goto l110;

                cplot(x, y, k);
                cplot(x, ymax - y, k);
            }
        }
    }

        // color cycling - standard mode
        for (k = 100; k >= 0; k--) {
            for (y = ymax; y >= 0; y--) {
                for (x = xmax; x >= 0; x--)
                    cplot(x, y, cpoint(x, y) + 1);
            }
        }

}
