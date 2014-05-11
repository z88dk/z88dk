
; int zx_pattern_fill(uint x, uint y, void *pattern, uint depth)

PUBLIC zx_pattern_fill_callee

zx_pattern_fill_callee:

   pop af
   pop bc
   pop de
   pop hl
   pop ix
   push af
   
   ld a,ixl
   ld h,l
   ld l,a
   
   INCLUDE "arch/zx/graphics/z80/asm_zx_pattern_fill.asm"
