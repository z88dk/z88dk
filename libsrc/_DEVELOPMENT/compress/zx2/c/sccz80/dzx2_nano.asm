
; void dzx2_nano(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx2

PUBLIC dzx2_nano

EXTERN asm_dzx2_nano

dzx2_nano:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx2_nano
