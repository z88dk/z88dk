; void *sms_memcpy_vram_to_mem(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_memcpy_vram_to_mem

EXTERN asm_sms_memcpy_vram_to_mem

_sms_memcpy_vram_to_mem:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af

   jp asm_sms_memcpy_vram_to_mem
