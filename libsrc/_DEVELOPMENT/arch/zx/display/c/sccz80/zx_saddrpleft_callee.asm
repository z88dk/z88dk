
; void *zx_saddrpleft(void *saddr, uchar bitmask)

SECTION code_clib
SECTION code_arch

PUBLIC zx_saddrpleft_callee

EXTERN asm_zx_saddrpleft

zx_saddrpleft_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_zx_saddrpleft
