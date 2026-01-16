#ifndef _PLAYFX_H
#define _PLAYFX_H

#define FX_SELECT   0
#define FX_MOVE     1
#define FX_EXPLO    2
#define FX_FIRE     3
#define FX_ALARM    4

extern void playfx(unsigned int fx) __z88dk_fastcall;

#endif
