#include <stdlib.h>

extern void linedraw(int x0, int y0, int x1, int y1, void (*pixel)(int x, int y)) __stdc;

void boxdraw(int x0, int y0, int w, int h, void (*pixel)(int x, int y)) __stdc {
  linedraw(x0, y0, x0+w, y0,pixel);
  linedraw(x0, y0+h, x0+w, y0+h,pixel);
  linedraw(x0, y0, x0, y0+h,pixel);
  linedraw(x0+w, y0, x0+w, y0+h,pixel);
}
