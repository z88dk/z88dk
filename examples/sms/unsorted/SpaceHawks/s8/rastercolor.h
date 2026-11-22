#ifndef RASTERCOLOR_H_
#define RASTERCOLOR_H_

#include "types.h"

void rastercolor_init( );
#ifdef TARGET_GG
void rastercolor_fill(u16* pal, u8 idx); 
void rastercolor_setRowColor(u8 row, u16* pal, u8 idx);
#else
void rastercolor_fill(u8* pal, u8 idx);
void rastercolor_setRowColor(u8 row, u8* pal, u8 idx);
#endif

void inline rastercolor_start( );
void rastercolor_hint( );
void rastercolor_vint( );

#endif /* RASTERCOLOR_H_ */
