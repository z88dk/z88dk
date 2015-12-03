
; int zx_pattern_fill(uint x, uint y, void *pattern, uint depth)

SECTION code_clib
SECTION code_arch

PUBLIC zx_pattern_fill_callee, l0_zx_pattern_fill_callee

EXTERN asm_zx_pattern_fill

zx_pattern_fill_callee:

   pop af
   pop bc
   pop de
   pop hl
   pop ix
   push af

l0_zx_pattern_fill_callee:

   ld a,ixl
   ld h,l
   ld l,a
   
   jp asm_zx_pattern_fill
