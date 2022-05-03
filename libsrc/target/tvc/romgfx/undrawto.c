/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Erases a line from the current pen position using
 *  the standard ROM gfx library provided by TVC
 *  (in fact draws a line using the actual paper color)
 *
 */

#include <graphics.h>
#include <tvc.h>

void undrawto(int x2, int y2) {
    struct composite_color cp;
    struct composite_color ci;
    char lmode = tvc_get_linemode();
    tvc_get_paper(&cp);
    tvc_get_ink(&ci);
    tvc_set_ink(cp);
    drawto(x2, y2);
    tvc_set_ink(ci);
    tvc_set_linemode(lmode);
}