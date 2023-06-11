

#include "regis.h"


void __regis_plot(int16_t x, uint16_t y) __z88dk_callee
{
    __regis_move_abs(x,y);
    __regis_outstr("V[];");
}


