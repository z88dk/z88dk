/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Erases a point (pixel, plot) using the standard ROM gfx library provided by TVC
 *  (in fact draws a point using the actual paper color)
 *
 */

#include <graphics.h>
#include <tvc.h>

void unplot(int x, int y) {
    struct composite_color cp;
    struct composite_color ci;
    char lmode = tvc_get_linemode();
    tvc_get_paper(&cp);
    tvc_get_ink(&ci);
    tvc_set_ink(cp);
    plot(x,y);
    tvc_set_ink(ci);
    tvc_set_linemode(lmode);
}