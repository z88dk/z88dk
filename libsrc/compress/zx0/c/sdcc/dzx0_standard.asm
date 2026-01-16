
; void dzx0_standard(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC _dzx0_standard

EXTERN asm_dzx0_standard

_dzx0_standard:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dzx0_standard
