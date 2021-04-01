
; void dzx1_smart_rcs_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_smart_rcs_callee

EXTERN asm_dzx1_smart_rcs

dzx1_smart_rcs_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_dzx1_smart_rcs
