; void *sms_memcpy_mem_to_cram(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_memcpy_mem_to_cram_callee

EXTERN asm_sms_memcpy_mem_to_cram

_sms_memcpy_mem_to_cram_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af

   jp asm_sms_memcpy_mem_to_cram
