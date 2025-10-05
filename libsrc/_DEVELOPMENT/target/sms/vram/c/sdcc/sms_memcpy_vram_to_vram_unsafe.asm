; void *sms_memcpy_vram_to_vram_unsafe(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_memcpy_vram_to_vram_unsafe

EXTERN asm_sms_memcpy_vram_to_vram_unsafe

_sms_memcpy_vram_to_vram_unsafe:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af

   jp asm_sms_memcpy_vram_to_vram_unsafe
