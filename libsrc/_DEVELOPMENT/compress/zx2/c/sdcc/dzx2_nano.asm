
; void dzx2_nano(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx2

PUBLIC _dzx2_nano

EXTERN asm_dzx2_nano

_dzx2_nano:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dzx2_nano
