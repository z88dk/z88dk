
; void dzx7_standard_back(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC _dzx7_standard_back

EXTERN asm_dzx7_standard_back

_dzx7_standard_back:

   pop af
   pop hl
   pop de

   push de
   push hl
   push af

   jp asm_dzx7_standard_back
