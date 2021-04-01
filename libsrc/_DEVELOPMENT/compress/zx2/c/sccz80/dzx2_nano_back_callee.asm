
; void dzx2_nano_back_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx2

PUBLIC dzx2_nano_back_callee

EXTERN asm_dzx2_nano_back

dzx2_nano_back_callee:

   pop hl
   pop de
   ex (sp),hl

   jp asm_dzx2_nano_back
