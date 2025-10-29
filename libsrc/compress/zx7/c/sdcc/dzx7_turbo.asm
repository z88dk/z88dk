
; void dzx7_turbo(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC _dzx7_turbo

EXTERN asm_dzx7_turbo

_dzx7_turbo:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dzx7_turbo
