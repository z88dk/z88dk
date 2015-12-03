
; int zx_pattern_fill(uint x, uint y, void *pattern, uint depth)

SECTION code_clib
SECTION code_arch

PUBLIC zx_pattern_fill

EXTERN l0_zx_pattern_fill_callee

zx_pattern_fill:

   pop af
   pop bc
   pop de
   pop hl
   pop ix
   
   push hl
   push hl
   push de
   push bc
   push af

   jp l0_zx_pattern_fill_callee
