
; int zx_pattern_fill(uint x, uint y, void *pattern, uint depth)

XDEF zx_pattern_fill

zx_pattern_fill:

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
   
   INCLUDE "../../z80/asm_zx_pattern_fill.asm"
