#include "regis.h"


void __regis_move_abs(int16_t x, int16_t y)
{
    char buf[20];
    __regis_outstr("P[");
    itoa(x, buf, 10);
    __regis_outstr(buf);
    __regis_outc(',');
    itoa(y, buf, 10);
    __regis_outstr(buf);
    __regis_outc(']');
    __regis_savexy(x,y);
}

void __regis_move_rel(int16_t xp, int16_t yp)
{
    char buf[20];
    __regis_outstr("P[+");
    itoa(xp, buf, 10);
    __regis_outstr(buf);
    __regis_outstr(",+");
    itoa(yp, buf, 10);
    __regis_outstr(buf);
    __regis_outc(']');
    __regis_savexy(__regis_getx() + xp, __regis_gety() + yp);
}

