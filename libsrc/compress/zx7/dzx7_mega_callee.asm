
; void dzx7_mega_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC _dzx7_mega_callee

EXTERN asm_dzx7_mega

_dzx7_mega_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_dzx7_mega
