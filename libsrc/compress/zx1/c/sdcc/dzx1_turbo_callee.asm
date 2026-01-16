
; void dzx1_turbo_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC _dzx1_turbo_callee

EXTERN asm_dzx1_turbo

_dzx1_turbo_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_dzx1_turbo
