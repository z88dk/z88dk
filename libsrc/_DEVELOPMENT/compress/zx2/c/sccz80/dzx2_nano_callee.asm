
; void dzx2_nano_callee(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx2

PUBLIC dzx2_nano_callee

EXTERN asm_dzx2_nano

dzx2_nano_callee:

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
   
   jp asm_dzx2_nano
