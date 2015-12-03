
; void dzx7_standard_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_standard_callee

EXTERN asm_dzx7_standard

dzx7_standard_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_dzx7_standard
