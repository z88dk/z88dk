
; unsigned int sms_dzx7_standard_vram_unsafe(void *src, unsigned int dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC sms_dzx7_standard_vram_unsafe_callee

EXTERN asm_sms_dzx7_standard_vram_unsafe

sms_dzx7_standard_vram_unsafe_callee:

   pop hl
   pop de
   ex (sp),hl

   jp asm_sms_dzx7_standard_vram_unsafe
