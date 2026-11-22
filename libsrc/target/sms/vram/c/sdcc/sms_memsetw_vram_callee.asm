; void *sms_memsetw_vram(void *dst, unsigned int c, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_memsetw_vram_callee

EXTERN asm_sms_memsetw_vram

_sms_memsetw_vram_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_sms_memsetw_vram
