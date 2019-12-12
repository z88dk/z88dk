#include <tvc.h>
#include <stdint.h>

void tvc_set_ink(color_or_index c) {
    int res = tvc_get_vmode();
    switch (res) {
        case 0:  // 2 color
        case 1:  // 4 color
            *((uint8_t *)0x0B4D) = c.paletteIndex;
            break;
        case 2:  // 16 color
            uint8_t cnum = (c.color & CINTENSITY) == CINTENSITY ? 8 : 0;
            cnum |= (c.color & CBLUE);
            cnum |= (c.color & CRED) == CRED ? 2 : 0;
            cnum |= (c.color & CGREEN) == CGREEN ? 4 : 0;

            *((uint8_t *)0x0B4D) = cnum;   
    }
}
