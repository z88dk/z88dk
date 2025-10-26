
#include <graphics.h>

#include "regis.h"


void gfx_refresh(void)
{
    __regis_outstr("\x1b\\");
    __regis_outstr("\x1bP0p");
}


