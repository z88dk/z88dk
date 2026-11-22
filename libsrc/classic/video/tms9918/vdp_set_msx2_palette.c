

#include <video/v9938.h>

const uint16_t msx2_palette[] =
{
    RGB16(0, 0, 0), // Transparent
    PAL_MSX2_BLACK,
    PAL_MSX2_MEDIUM_GREEN,
    PAL_MSX2_LIGHT_GREEN,
    PAL_MSX2_DARK_BLUE,
    PAL_MSX2_LIGHT_BLUE,
    PAL_MSX2_DARK_RED,
    PAL_MSX2_CYAN,
    PAL_MSX2_MEDIUM_RED,
    PAL_MSX2_LIGHT_RED,
    PAL_MSX2_DARK_YELLOW,
    PAL_MSX2_LIGHT_YELLOW,
    PAL_MSX2_DARK_GREEN,
    PAL_MSX2_MAGENTA,
    PAL_MSX2_GRAY,
    PAL_MSX2_WHITE
};


void vdp_set_msx1_palette(void) 
{
    vdp_set_palette(msx2_palette);
}