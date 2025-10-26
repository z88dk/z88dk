#ifndef _TEK_H
#define _TEK_H

#include <stdint.h>
#include <stdlib.h>
#include <graphics.h>

// Implemented by user
extern void __regis_outc(uint8_t c) __z88dk_fastcall;
extern void __regis_outstr(char *s) __z88dk_fastcall;


// Library internals
extern void __regis_savexy(int x, int y) __z88dk_callee;
extern int  __regis_getx();
extern int  __regis_gety();
extern void __regis_move_abs(int16_t x, int16_t y);
extern void __regis_move_rel(int16_t x, int16_t y);

extern void __regis_plot(int16_t x, uint16_t y) __z88dk_callee;



#endif
