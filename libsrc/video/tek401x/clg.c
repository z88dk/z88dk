#include <graphics.h>

#include "tek.h"


void clg() {
  __tek_outc(0x1B);
  __tek_outc(0x0c);
//__tek_outc(0x0d);__tek_outc(0x0a);
}

