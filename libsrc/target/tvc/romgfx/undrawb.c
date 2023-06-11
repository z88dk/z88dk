/*
 *
 *  Videoton TV Computer C stub
 *  Sandor Vass - 2022
 *
 *  Draws a box using the standard ROM gfx library provided by TVC
 *
 */


#include <graphics.h>
#include <tvc.h>

extern void __LIB__ undrawb(int tlx, int tly, int width, int height) __smallc {
    struct composite_color cp;
    struct composite_color ci;
    char lmode = tvc_get_linemode();
    tvc_set_linemode(0);
    tvc_get_paper(&cp);
    tvc_get_ink(&ci);
    tvc_set_ink(cp);
    drawb(tlx, tly, width, height);
    tvc_set_ink(ci);
    tvc_set_linemode(lmode);
}