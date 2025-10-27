; void *sms_memcpy_mem_to_cram(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_memcpy_mem_to_cram_callee

EXTERN asm_sms_memcpy_mem_to_cram

sms_memcpy_mem_to_cram_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

   jp asm_sms_memcpy_mem_to_cram
