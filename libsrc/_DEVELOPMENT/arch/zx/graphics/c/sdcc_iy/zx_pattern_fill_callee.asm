
; int zx_pattern_fill_callee(uint x, uint y, void *pattern, uint depth)

SECTION code_arch

PUBLIC _zx_pattern_fill_callee, l0_zx_pattern_fill_callee

_zx_pattern_fill_callee:

   pop af
   pop hl
   pop ix
   pop de
   pop bc
   push af

l0_zx_pattern_fill_callee:

   ld a,ixl
   ld h,a
   
   INCLUDE "arch/zx/graphics/z80/asm_zx_pattern_fill.asm"
