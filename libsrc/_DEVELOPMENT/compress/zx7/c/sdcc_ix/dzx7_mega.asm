
; void dzx7_mega(void *src, void *dst)

SECTION code_compress_zx7

PUBLIC _dzx7_mega

_dzx7_mega:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "compress/zx7/z80/asm_dzx7_mega.asm"
