; void *sms_memsetw_vram(void *dst, unsigned int c, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_memsetw_vram

EXTERN asm_sms_memsetw_vram

_sms_memsetw_vram:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   jp asm_sms_memsetw_vram
