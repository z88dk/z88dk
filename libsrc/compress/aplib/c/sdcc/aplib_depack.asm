
; void aplib_depack(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC _aplib_depack

EXTERN asm_aplib_depack

_aplib_depack:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_aplib_depack
 