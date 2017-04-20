; void sms_setw_vram(unsigned int c, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC sms_setw_vram_callee

EXTERN asm_sms_setw_vram

sms_setw_vram_callee:

   pop af
   pop bc
   pop de
   push af
   
   jp asm_sms_setw_vram
