
; unsigned int sms_dzx7_standard_vram(void *src, unsigned int dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC sms_dzx7_standard_vram_callee

EXTERN asm_sms_dzx7_standard_vram

sms_dzx7_standard_vram_callee:

   pop hl
   pop de
   ex (sp),hl

   jp asm_sms_dzx7_standard_vram
