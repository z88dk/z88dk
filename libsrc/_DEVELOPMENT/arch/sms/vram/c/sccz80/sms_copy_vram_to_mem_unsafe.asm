; void *sms_copy_vram_to_mem_unsafe(void *dst, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC _sms_copy_vram_to_mem_unsafe

EXTERN asm_sms_copy_vram_to_mem_unsafe

_sms_copy_vram_to_mem_unsafe:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_sms_copy_vram_to_mem_unsafe
