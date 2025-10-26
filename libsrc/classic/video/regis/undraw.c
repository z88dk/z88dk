
#include <graphics.h>
#include "regis.h"

// Un draw a line from (x1, y1) to (x2, y2)
void undraw(int16_t x1, int16_t y1, int16_t x2, int16_t y2) __z88dk_callee 
{
    char buf[20];

    __regis_plot(x1, y1);  // Move to the right place
    __regis_outstr("V(W(E))[][");
    itoa(x2, buf, 10);
    __regis_outstr(buf);
    __regis_outc(',');
    itoa(y2, buf, 10);
    __regis_outstr(buf);
    __regis_outc(']');
    __regis_savexy(x2,y2);
}
