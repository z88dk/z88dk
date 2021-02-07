
; void dzx0_turbo_back(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC dzx0_turbo_back

EXTERN asm_dzx0_turbo_back

dzx0_turbo_back:

   pop af
   pop de
   pop hl

   push hl
   push de
   push af

   jp asm_dzx0_turbo_back
