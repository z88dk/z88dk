
; void dzx0_standard(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC dzx0_standard

EXTERN asm_dzx0_standard

dzx0_standard:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx0_standard
