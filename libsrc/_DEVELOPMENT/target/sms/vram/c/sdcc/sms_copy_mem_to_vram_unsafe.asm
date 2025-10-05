; void sms_copy_mem_to_vram_unsafe(void *src, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC _sms_copy_mem_to_vram_unsafe

EXTERN asm_sms_copy_mem_to_vram_unsafe

_sms_copy_mem_to_vram_unsafe:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_sms_copy_mem_to_vram_unsafe
