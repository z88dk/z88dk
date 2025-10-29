#include <graphics.h>
#include "tek.h"

// Continue with drawing a line to (x1, y1)
void drawto(int16_t x1, int16_t y1) __z88dk_callee {
  int x = __tek_getx();
  int y = __tek_gety();
  draw(x,y, 1, y1);
}
