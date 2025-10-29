; void sms_setw_vram_unsafe(unsigned int c, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC sms_setw_vram_unsafe

EXTERN asm_sms_setw_vram_unsafe

sms_setw_vram_unsafe:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_sms_setw_vram_unsafe
