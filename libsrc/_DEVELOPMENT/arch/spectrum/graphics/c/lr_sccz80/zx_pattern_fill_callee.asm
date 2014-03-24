
; int zx_pattern_fill(uint x, uint y, void *pattern, uint depth)

XDEF zx_pattern_fill_callee

zx_pattern_fill_callee:

   pop af
   pop bc
   pop de
   pop hl
   exx
   pop bc
   push af
   
   ld a,c
   exx
   ld h,l
   ld l,a
   
   INCLUDE "arch/spectrum/graphics/z80/asm_zx_pattern_fill.asm"
