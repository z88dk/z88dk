
; void dzx1_turbo(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC _dzx1_turbo

EXTERN asm_dzx1_turbo

_dzx1_turbo:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dzx1_turbo
