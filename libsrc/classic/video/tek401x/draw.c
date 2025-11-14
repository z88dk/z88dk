
#include <graphics.h>
#include "tek.h"

// Draw a line from (x1, y1) to (x2, y2)
void draw(int16_t x1, int16_t y11, int16_t x2, int16_t y22) __z88dk_callee {
  int16_t y1 = getmaxy() - y11;
  int16_t y2 = getmaxy() - y22;
  __tek_mode(MODE_GRAPH);
  __tek_outc(0x20 + ((y1 >> 5) & 0x1F));
  __tek_outc(0x60 + ((y1) & 0x1F));
  __tek_outc(0x20 + ((x1 >> 5) & 0x1F));
  __tek_outc(0x40 + ((x1) & 0x1F));
  __tek_outc(0x20 + ((y2 >> 5) & 0x1F));
  __tek_outc(0x60 + ((y2) & 0x1F));
  __tek_outc(0x20 + ((x2 >> 5) & 0x1F));
  __tek_outc(0x40 + ((x2) & 0x1F));
  __tek_savexy(x2, y22);
}

