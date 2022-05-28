/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Erases a line using the standard ROM gfx library provided by TVC
 *  (in fact draws a line using the actual paper color)
 */

#include <graphics.h>
#include <tvc.h>

void __LIB__ undraw(int x1, int y1, int x2, int y2) {
    struct composite_color cp;
    struct composite_color ci;
    char lmode = tvc_get_linemode();
    tvc_set_linemode(0);
    tvc_get_paper(&cp);
    tvc_get_ink(&ci);
    tvc_set_ink(cp);
    draw(x1, y1, x2, y2);
    tvc_set_ink(ci);
    tvc_set_linemode(lmode);
}