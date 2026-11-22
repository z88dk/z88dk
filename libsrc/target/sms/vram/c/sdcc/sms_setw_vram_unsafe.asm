; void sms_setw_vram_unsafe(unsigned int c, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC _sms_setw_vram_unsafe

EXTERN asm_sms_setw_vram_unsafe

_sms_setw_vram_unsafe:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_sms_setw_vram_unsafe
