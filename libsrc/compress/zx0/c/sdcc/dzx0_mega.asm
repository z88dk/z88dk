
; void dzx0_mega(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC _dzx0_mega

EXTERN asm_dzx0_mega

_dzx0_mega:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dzx0_mega
