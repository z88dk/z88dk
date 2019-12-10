#include <tvc.h>
#include <stdint.h>

void tvc_set_ink(color_or_index c) {
    uint8_t *memP;
    int res = tvc_get_vmode();
    switch (res) {
        case 0:  // 2 color
        case 1:  // 4 color
            memP = (uint8_t *)0x0B4D;
            *memP = c.paletteIndex;
            break;
        case 2:  // 16 color
        case 3:  // 16 color
            int cnum = c.color & CINTENSITY == CINTENSITY ? 8 : 0;
            cnum |= c.color & CBLUE;
            cnum |= c.color & CRED == CRED ? 2 : 0;
            cnum |= c.color & CGREEN == CGREEN ? 4 : 0;

            memP = (uint8_t *)0x0B4D;
            *memP = cnum;
    }
}
