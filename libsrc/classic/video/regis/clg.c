#include "regis.h"


void clg()
{
    __regis_outstr("\x1b[2J\x1bP2pS(C0)S(E)\n");
}

