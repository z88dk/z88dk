
#ifndef __TS2068_H__
#define __TS2068_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <spectrum.h>          // for now anyway

///////////////////
// SET VIDEO MODE
///////////////////

#define VMOD_SPEC    0         // 256x192 pix, 32x24 attr
#define VMOD_HICLR   2         // 256x192 pix, 32x192 attr
#define VMOD_HIRES   6         // 512x192 pix

#define VMOD_DFILE0  0
#define VMOD_DFILE1  1

extern void __LIB__  ts_vmod(uchar mode);

#endif
