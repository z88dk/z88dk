; void *sms_set_vram(unsigned char c, unsigned int n)

SECTION code_clib
SECTION code_crt_common

PUBLIC sms_set_vram

EXTERN asm_sms_set_vram

sms_set_vram:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   ld a,l
   jp asm_sms_set_vram
