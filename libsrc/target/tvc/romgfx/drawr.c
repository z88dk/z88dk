/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Draws a line from the current pen position to
 *  a relative position using the standard ROM 
 *  gfx library provided by TVC
 */


#include <graphics.h>

void __LIB__ drawr(int px, int py) {
    pen_down();
    move(px, py);
}