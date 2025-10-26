#include <graphics.h>
#include "regis.h"


void uncircle(int x, int y, int radius, int skip)
{
    char buf[20];
    __regis_move_abs(x,y);
    __regis_outstr("C(W(E))[+");
    itoa(radius, buf, 10);
    __regis_outstr(buf);
    __regis_outc(']');
}
