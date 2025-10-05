; void *sms_set_vram(unsigned char c, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC sms_set_vram_callee

EXTERN asm_sms_set_vram

sms_set_vram_callee:

   pop hl
   pop bc
   ex (sp),hl

   ld a,l
   jp asm_sms_set_vram
