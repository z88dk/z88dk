
; void dzx1_standard_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_standard_callee

EXTERN asm_dzx1_standard

dzx1_standard_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_dzx1_standard
