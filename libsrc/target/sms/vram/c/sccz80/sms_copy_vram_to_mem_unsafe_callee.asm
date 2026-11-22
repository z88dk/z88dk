; void *sms_copy_vram_to_mem_unsafe(void *dst, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC sms_copy_vram_to_mem_unsafe_callee

EXTERN asm_sms_copy_vram_to_mem_unsafe

sms_copy_vram_to_mem_unsafe_callee:

   pop hl
   pop bc
   ex (sp),hl

   jp asm_sms_copy_vram_to_mem_unsafe

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sms_copy_vram_to_mem_unsafe_callee
defc _sms_copy_vram_to_mem_unsafe_callee = sms_copy_vram_to_mem_unsafe_callee
ENDIF

