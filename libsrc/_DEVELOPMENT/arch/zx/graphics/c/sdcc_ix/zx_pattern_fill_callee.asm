
; int zx_pattern_fill_callee(uchar x, uchar y, void *pattern, uint depth)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_pattern_fill_callee

EXTERN asm_zx_pattern_fill

_zx_pattern_fill_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   push ix

   call asm_zx_pattern_fill

   pop ix   
   ret
