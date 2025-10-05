; void *sms_memsetw_vram_unsafe(void *dst, unsigned int c, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_memsetw_vram_unsafe_callee

EXTERN asm_sms_memsetw_vram_unsafe

_sms_memsetw_vram_unsafe_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_sms_memsetw_vram_unsafe
