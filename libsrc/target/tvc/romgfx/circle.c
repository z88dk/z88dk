/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Draws a circle using the standard ROM gfx library provided by TVC.
 *  This routine is way too slow, needs further optimizations because of the
 *  std plot routine calls. 
 *  The routine itself is a copy from the gfx/portable library.
 *
 */

#include <graphics.h>
#undef circle

void circle(int x0, int y0, int radius, int skip) {
    circle_callee(x0, y0, radius, skip);
}
