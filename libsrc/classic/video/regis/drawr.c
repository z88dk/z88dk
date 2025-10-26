#include <graphics.h>
#include "regis.h"

// Continue with drawing a line to (x1, y1)
void drawr(int16_t x1, int16_t y1) __z88dk_callee {
  int x = __regis_getx();
  int y = __regis_gety();
  draw(x,y, x+x1, y+y1);
}
