
; void dzx7_turbo(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_turbo

EXTERN asm_dzx7_turbo

dzx7_turbo:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx7_turbo
