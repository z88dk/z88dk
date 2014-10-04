
; int zx_pattern_fill(uint x, uint y, void *pattern, uint depth)

SECTION seg_code_arch

PUBLIC _zx_pattern_fill

_zx_pattern_fill:

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
   
   INCLUDE "arch/zx/graphics/z80/asm_zx_pattern_fill.asm"
