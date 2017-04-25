; void sms_setw_vram(unsigned int c, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC _sms_setw_vram

EXTERN asm_sms_setw_vram

_sms_setw_vram:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_sms_setw_vram
