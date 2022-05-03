/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Draws a circle using the standard ROM gfx library provided by TVC.
 *  This routine is way too slow, needs further optimizations because of the
 *  std plot routine calls. 
 *  The routine itself is a copy from the gfx/portable library.
 *  Because of the define in graphics.h instead of the circle routine, this
 *  one is called directly.
 *
 */

#include <graphics.h>

void circle_callee(int x0, int y0, int radius, int skip) {
    int x = radius;
    int y = 0;
    int err = 0;

    while (x >= y) {
        plot(x0 + x, y0 + y);
        plot(x0 + y, y0 + x);
        plot(x0 - y, y0 + x);
        plot(x0 - x, y0 + y);
        plot(x0 - x, y0 - y);
        plot(x0 - y, y0 - x);
        plot(x0 + y, y0 - x);
        plot(x0 + x, y0 - y);

        if (err <= 0) {
            y += skip;
            err += 2*y + 1;
        }

        if (err > 0) {
            x -= skip;
            err -= 2*x + 1;
        }
    }
}
