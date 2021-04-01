
; void dzx2_nano_back(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx2

PUBLIC dzx2_nano_back

EXTERN asm_dzx2_nano_back

dzx2_nano_back:

   pop af
   pop de
   pop hl

   push hl
   push de
   push af

   jp asm_dzx2_nano_back
