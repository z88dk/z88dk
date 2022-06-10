/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Draws a line from the current pen position to
 *  an absolute coordinate using the standard ROM 
 *  gfx library provided by TVC
 *
 */

#include <graphics.h>

void drawto(int x2, int y2) {
    pen_down();
    setpos(x2, y2);
}