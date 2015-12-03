
; int zx_pattern_fill(uint x, uint y, void *pattern, uint depth)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_pattern_fill

EXTERN l0_zx_pattern_fill_callee

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
   push bc
   push hl
   push af

   jp l0_zx_pattern_fill_callee
