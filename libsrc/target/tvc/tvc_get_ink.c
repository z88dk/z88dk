#include <tvc.h>
#include <stdint.h>

void tvc_get_ink(color_or_index *retVal) {
    int res = tvc_get_vmode();
    switch (res) {
        case 0:  // 2 color
        case 1:  // 4 color
            retVal->paletteIndex = *((uint8_t *)0x0B4D);
            break;
        case 2:  // 16 color
            uint8_t cnum = *((uint8_t *)0x0B4D);
            retVal->color  = (cnum & 8) != 0 ? CINTENSITY : 0;
            retVal->color |= (cnum & 4) != 0 ? CGREEN     : 0;
            retVal->color |= (cnum & 2) != 0 ? CRED       : 0;
            retVal->color |= (cnum & 1) != 0 ? CBLUE      : 0;
    }
    return retVal;
}
