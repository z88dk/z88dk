/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Draws a line using the standard ROM gfx library provided by TVC
 *
 */


#include <graphics.h>

void __LIB__ draw(int x1, int y1, int x2, int y2) __smallc {
    pen_up();
    setpos(x1, y1);
    pen_down();
    setpos(x2, y2);
}