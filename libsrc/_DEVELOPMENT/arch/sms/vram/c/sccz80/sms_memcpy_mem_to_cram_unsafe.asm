; void *sms_memcpy_mem_to_cram_unsafe(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_memcpy_mem_to_cram_unsafe

EXTERN asm_sms_memcpy_mem_to_cram_unsafe

sms_memcpy_mem_to_cram_unsafe:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af

   jp asm_sms_memcpy_mem_to_cram_unsafe
