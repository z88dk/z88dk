
; int zx_pattern_fill(uint x, uint y, void *pattern, uint depth)

XDEF zx_pattern_fill

zx_pattern_fill:

   pop af
   pop bc
   pop de
   pop hl
   exx
   pop bc
   
   push bc
   exx
   push hl
   push de
   push bc
   push af
   
   ld h,l
   exx
   ld a,c
   exx
   ld l,a
   
   INCLUDE "../../z80/asm_zx_pattern_fill.asm"
