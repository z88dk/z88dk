
; int zx_pattern_fill(uint x, uint y, void *pattern, uint depth)

PUBLIC _zx_pattern_fill

_zx_pattern_fill:

   pop af
   pop hl
   exx
   pop bc
   exx
   pop de
   pop bc
   
   push bc
   push de
   exx
   push bc
   exx
   push hl
   push af
   
   exx
   ld a,c
   exx
   ld h,a
   
   push ix
   call asm_zx_pattern_fill
   pop ix
   
   ret
   
   INCLUDE "arch/zx/graphics/z80/asm_zx_pattern_fill.asm"
