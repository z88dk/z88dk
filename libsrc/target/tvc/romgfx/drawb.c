/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Draws a box using the standard ROM gfx library provided by TVC
 *
 */


#include <graphics.h>

extern void __LIB__ drawb(int tlx, int tly, int width, int height) __smallc {
    pen_up();
    setpos(tlx, tly);
    pen_down();
    setpos(tlx, tly+height);
    setpos(tlx+width, tly+width);
    setpos(tlx+width, tly);
    setpos(tlx, tly);
}