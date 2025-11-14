; void *sms_memcpy_mem_to_cram(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_memcpy_mem_to_cram

EXTERN asm_sms_memcpy_mem_to_cram

_sms_memcpy_mem_to_cram:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af

   jp asm_sms_memcpy_mem_to_cram
