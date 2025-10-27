
; void dzx2_nano_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx2

PUBLIC _dzx2_nano_callee

EXTERN asm_dzx2_nano

_dzx2_nano_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_dzx2_nano
