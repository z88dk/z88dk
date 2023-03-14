#ifndef _TEK_H
#define _TEK_H

#include <stdint.h>

// Implemented by user
extern void __tek_outc(uint8_t c) __z88dk_fastcall;


// Library internals
extern void __tek_savexy(int x, int y) __z88dk_callee;
extern int  __tek_getx();
extern int  __tek_gety();
extern void __tek_mode(int mode);


#define MODE_ALPHA   1
#define MODE_GRAPH   2
#define MODE_POINT    3


#endif
