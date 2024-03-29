
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
 
; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _aplib_depack_callee
defc _aplib_depack_callee = aplib_depack_callee
ENDIF

