

#ifndef __ARCH_VECTOR06C_H__
#define __ARCH_VECTOR06C_H__

#include <sys/compiler.h>

// Load the palette (all 16 colours)
extern void __LIB__ load_palette(unsigned char *palette) __z88dk_fastcall;

#endif
