; void *sms_set_vram_unsafe(unsigned char c, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC _sms_set_vram_unsafe_callee

EXTERN asm_sms_set_vram_unsafe

_sms_set_vram_unsafe_callee:

   pop hl
   dec sp
   pop af
   pop bc
   push hl

   jp asm_sms_set_vram_unsafe
