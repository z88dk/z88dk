; void *sms_set_vram(unsigned char c, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC _sms_set_vram

EXTERN asm_sms_set_vram

_sms_set_vram:

   pop hl
   dec sp
   pop af
   pop bc
   
   push bc
   push af
   inc sp
   push hl
   
   jp asm_sms_set_vram
