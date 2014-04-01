
; int zx_pattern_fill(uint x, uint y, void *pattern, uint depth)

XDEF zx_pattern_fill

zx_pattern_fill:

   pop af
   pop hl
   pop ix
   pop de
   pop bc
   
   push bc
   push de
   push ix
   push hl
   push af
   
   ld a,ixl
   ld h,a
   
   INCLUDE "arch/spectrum/graphics/z80/asm_zx_pattern_fill.asm"
