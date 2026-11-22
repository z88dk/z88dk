#include "tek.h"

// Draw a single dot
void __tek_plot(int16_t x, int16_t y) {
  __tek_mode(MODE_POINT);
  __tek_outc(0x20 + ((y >> 5) & 0x1F));
  __tek_outc(0x60 + ((y) & 0x1F));
  __tek_outc(0x20 + ((x >> 5) & 0x1F));
  __tek_outc(0x40 + ((x) & 0x1F));
}

