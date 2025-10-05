; void *sms_memcpy_mem_to_cram_unsafe(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_memcpy_mem_to_cram_unsafe_callee

EXTERN asm_sms_memcpy_mem_to_cram_unsafe

sms_memcpy_mem_to_cram_unsafe_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

   jp asm_sms_memcpy_mem_to_cram_unsafe
