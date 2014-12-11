
; int zx_pattern_fill(uint x, uint y, void *pattern, uint depth)

SECTION code_arch

PUBLIC zx_pattern_fill

EXTERN asm_zx_pattern_fill

zx_pattern_fill:

   pop af
   pop bc
   pop de
   pop hl
   pop ix
   
   push ix
   push hl
   push de
   push bc
   push af
   
   ld a,ixl
   ld h,l
   ld l,a
   
   jp asm_zx_pattern_fill
