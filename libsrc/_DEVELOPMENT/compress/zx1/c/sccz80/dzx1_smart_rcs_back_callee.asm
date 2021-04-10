
; void dzx1_smart_rcs_back_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC dzx1_smart_rcs_back_callee

EXTERN asm_dzx1_smart_rcs_back

dzx1_smart_rcs_back_callee:

IF __CPU_GBZ80__
   pop bc
   pop de
   pop hl
   push bc
ELSE
   pop hl
   pop de
   ex (sp),hl
ENDIF

   jp asm_dzx1_smart_rcs_back