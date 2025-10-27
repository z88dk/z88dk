; void *sms_memcpy_mem_to_cram(void *dst, void *src, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_memcpy_mem_to_cram

EXTERN asm_sms_memcpy_mem_to_cram

sms_memcpy_mem_to_cram:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af

   jp asm_sms_memcpy_mem_to_cram
