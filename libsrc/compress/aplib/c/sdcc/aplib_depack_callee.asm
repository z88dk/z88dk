
; void aplib_depack_callee(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC _aplib_depack_callee

EXTERN asm_aplib_depack

_aplib_depack_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_aplib_depack
 