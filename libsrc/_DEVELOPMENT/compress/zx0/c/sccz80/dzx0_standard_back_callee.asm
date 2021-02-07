
; void dzx0_standard_back_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC dzx0_standard_back_callee

EXTERN asm_dzx0_standard_back

dzx0_standard_back_callee:

   pop hl
   pop de
   ex (sp),hl

   jp asm_dzx0_standard_back
