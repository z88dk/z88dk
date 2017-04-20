; void *sms_copy_vram_to_mem_unsafe(void *dst, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC sms_copy_vram_to_mem_unsafe

EXTERN asm_sms_copy_vram_to_mem_unsafe

sms_copy_vram_to_mem_unsafe:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_sms_copy_vram_to_mem_unsafe
