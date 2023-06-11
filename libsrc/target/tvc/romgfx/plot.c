/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Draws a point (pixel, plot) using the standard ROM gfx library provided by TVC
 *
 */

#include <graphics.h>

void plot(int x, int y) {
    pen_up();
    setpos(x, y);
    pen_down();
}