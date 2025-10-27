; void sms_setw_vram(unsigned int c, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC sms_setw_vram

EXTERN asm_sms_setw_vram

sms_setw_vram:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af

   jp asm_sms_setw_vram
