# ZX SPECTRUM FZX PROPORTIONAL FONTS

[Original Documentation](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/font/fzx)  
[Plain Z88DK Header](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/clang/font/fzx.h)

Among the CRTs provided by Z88DK for the spectrum is one that adds fzx drivers for stdin and stdout so that proportional text can be output and scanned via printf and scanf.

This example, however, is going to use the fzx library directly and accordingly it selects a minimal CRT for compiles that has no FILEs instantiated at all.  For the spectrum, this selection is made by compiling with option `-startup=31`.

The fzx state is kept in a `struct fzx_state` whose definition is repeated below:

```
struct fzx_state
{
   uint8_t          jp;                // 195 = z80 jump instruction
   void            *fzx_draw;          // address of fzx_draw function
   struct fzx_font *font;              // selected font
   uint16_t         x;                 // x coordinate in pixels
   uint16_t         y;                 // y coordinate in pixels
   struct r_Rect16  paper;             // display area units in pixels
   uint16_t         left_margin;       // left margin in pixels
   uint8_t          space_expand;      // additional width added to space characters
   uint16_t         reserved;          // unused
   
   #ifdef __SPECTRUM
   
   // zx spectrum only below
   
   uint8_t          fgnd_attr;         // text colour
   uint8_t          fgnd_mask;         // set bits indicate kept background attribute bits

   #endif
};
```

The structure records things like current pixel coordinate, paper size, current font, draw mode and so on.  It's usually important to have a non-zero left margin as fonts can have characters that kern leftward from the left margin when rendered.

A program can have any number of these structures around to render text independently with different settings.

This program provides a simple example of using fzx to render text.

## Compiling the Example

sccz80 compile:
```
zcc +zx -vn -startup=31 -O3 -clib=new fzx_modes.c -o fzx_modes -create-app
```
zsdcc compile:
```
zcc +zx -vn -startup=31 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 fzx_modes.c -o fzx_modes -create-app
```
