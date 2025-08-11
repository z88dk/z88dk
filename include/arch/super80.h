#ifndef ARCH_SUPER80_H
#define ARCH_SUPER80_H


// Set the palette mode
#define SUPER80_PALETTE_RGB 0
#define SUPER80_PALETTE_COMPOSITE 1
extern int __LIB__ super80_set_palette_mode(int mode);
extern int __LIB__ super80_set_palette_mode_fastcall(int mode) __z88dk_fastcall;
#define super80_set_palette_mode(p) super80_set_palette_mode_fastcall(p)

#endif
