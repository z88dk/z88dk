; void sms_copy_mem_to_vram(void *src, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC _sms_copy_mem_to_vram

EXTERN asm_sms_copy_mem_to_vram

_sms_copy_mem_to_vram:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_sms_copy_mem_to_vram
