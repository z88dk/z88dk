; void sms_setw_vram(unsigned int c, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC _sms_setw_vram_callee

EXTERN asm_sms_setw_vram

_sms_setw_vram_callee:

   pop af
   pop de
   pop bc
   push af
   
   jp asm_sms_setw_vram
