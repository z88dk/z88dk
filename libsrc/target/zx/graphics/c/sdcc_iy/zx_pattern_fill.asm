
; int zx_pattern_fill(uchar x, uchar y, void *pattern, uint depth)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_pattern_fill

EXTERN asm_zx_pattern_fill

_zx_pattern_fill:

   pop af
   pop hl
   pop de
   pop bc

   push bc
   push de
   push hl
   push af

   jp asm_zx_pattern_fill
