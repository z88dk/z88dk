
; void aplib_depack(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC aplib_depack

EXTERN asm_aplib_depack

aplib_depack:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_aplib_depack
 
; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _aplib_depack
defc _aplib_depack = aplib_depack
ENDIF

