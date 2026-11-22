
; void dzx7_standard_back(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_standard_back

EXTERN asm_dzx7_standard_back

dzx7_standard_back:

   pop af
   pop de
   pop hl

   push hl
   push de
   push af

   jp asm_dzx7_standard_back
