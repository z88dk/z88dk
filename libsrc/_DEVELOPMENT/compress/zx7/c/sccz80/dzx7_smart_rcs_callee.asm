
; void dzx7_smart_rcs_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_smart_rcs_callee

EXTERN asm_dzx7_smart_rcs

dzx7_smart_rcs_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_dzx7_smart_rcs
