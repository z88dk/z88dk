
; void aplib_depack_callee(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC aplib_depack_callee

EXTERN asm_aplib_depack

aplib_depack_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_aplib_depack
 