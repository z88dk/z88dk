
; void dzx1_mega(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC _dzx1_mega

EXTERN asm_dzx1_mega

_dzx1_mega:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dzx1_mega
