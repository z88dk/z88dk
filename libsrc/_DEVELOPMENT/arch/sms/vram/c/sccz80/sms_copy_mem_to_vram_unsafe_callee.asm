; void sms_copy_mem_to_vram_unsafe(void *src, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC sms_copy_mem_to_vram_unsafe_callee

EXTERN asm_sms_copy_mem_to_vram_unsafe

sms_copy_mem_to_vram_unsafe_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_sms_copy_mem_to_vram_unsafe
