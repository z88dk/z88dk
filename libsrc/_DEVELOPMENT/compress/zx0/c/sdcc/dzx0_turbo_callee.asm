
; void dzx0_turbo_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC _dzx0_turbo_callee

EXTERN asm_dzx0_turbo

_dzx0_turbo_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_dzx0_turbo
