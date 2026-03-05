

#include <video/v9938.h>

const uint16_t msx1_palette[] =
{
    RGB16(0, 0, 0), // Transparent
    PAL_MSX1_BLACK,
    PAL_MSX1_MEDIUM_GREEN,
    PAL_MSX1_LIGHT_GREEN,
    PAL_MSX1_DARK_BLUE,
    PAL_MSX1_LIGHT_BLUE,
    PAL_MSX1_DARK_RED,
    PAL_MSX1_CYAN,
    PAL_MSX1_MEDIUM_RED,
    PAL_MSX1_LIGHT_RED,
    PAL_MSX1_DARK_YELLOW,
    PAL_MSX1_LIGHT_YELLOW,
    PAL_MSX1_DARK_GREEN,
    PAL_MSX1_MAGENTA,
    PAL_MSX1_GRAY,
    PAL_MSX1_WHITE
};


void vdp_set_msx1_palette(void) 
{
    vdp_set_palette(msx1_palette);
}