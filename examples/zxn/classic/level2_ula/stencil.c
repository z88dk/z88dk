/*=========================================================================

Small demo showing use of ULA and layer2 at the same time

=========================================================================*/

#include <graphics.h>
#include <lib3d.h>
#include <stdlib.h>
#include <conio.h>
#include <intrinsic.h>
#include <arch/zxn.h>
#include <arch/zxn/color.h>


unsigned char stencil[256 * 4];
int x, y, r, p;

void main()
{
    // Switch to 14Mhz mode
    ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);

    // We'll print to the ULA layer, and have graphics on layer2
    conio_set_screen_mode(0);
    zxn_set_graphics_mode(128);
    clg();

    // Setup the layer order
    ZXN_NEXTREGA(REG_SPRITE_LAYER_SYSTEM, RSLS_LAYER_PRIORITY_SUL);

    // Setup transparency
    ZXN_NEXTREG(REG_GLOBAL_TRANSPARENCY_COLOR, ZXN_RGB332_NEXTOS_BRIGHT_MAGENTA);

    // Setup the ULA layer. Mark most of the ULA layer as transparent
    zx_border(INK_BLACK);
    zx_cls_attr(0x5b); // bright magenta ink + paper (this affects ULA only)

    // paint polygon or circle
    for (;;) {
        // get a random position and size for the object
        x = rand() % getmaxx();
        y = rand() % getmaxy();
        r = rand() % (getmaxy() / 2);
        // if it does not go out of screen, then paint it..
        if (((x - r) > 0) && ((x + r) < getmaxx()) && ((y - r) > 0) && ((y + r) < getmaxy())) {
            stencil_init(stencil);
            p = rand() % 8;
            if (!p)
                stencil_add_circle(x, y, r, 1, stencil);
            else
                // rotate thepolygon by a random angle
                stencil_add_polygon(x, y, p + 2, r, rand() % 180, stencil);
            // fill object with a texture of a random brightness
            zx_setink(rand());
            stencil_render(stencil, rand() % 12);

            // And just print something to the ULA screen
            zx_setink(INK_WHITE);
            printf("%d %d %d\n", x, y, r);
        }

        // Allow changing of the grpahics mode
        int k = getk();
        if (k == '2') {
            clg();
            zxn_set_graphics_mode(128);
            clg();
        } else if (k == 'u') {
            clg();
            zxn_set_graphics_mode(0);
            clg();
        }
    }
}
