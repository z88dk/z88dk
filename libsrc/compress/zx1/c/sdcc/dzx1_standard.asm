
; void dzx1_standard(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC _dzx1_standard

EXTERN asm_dzx1_standard

_dzx1_standard:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dzx1_standard
