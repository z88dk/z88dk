
; void dzx0_turbo(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC _dzx0_turbo

EXTERN asm_dzx0_turbo

_dzx0_turbo:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dzx0_turbo
