; void *sms_memcpy_vram_to_vram(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_memcpy_vram_to_vram_callee

EXTERN asm_sms_memcpy_vram_to_vram

sms_memcpy_vram_to_vram_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

   jp asm_sms_memcpy_vram_to_vram
