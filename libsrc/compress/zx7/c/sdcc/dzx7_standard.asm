
; void dzx7_standard(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC _dzx7_standard

EXTERN asm_dzx7_standard

_dzx7_standard:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dzx7_standard
