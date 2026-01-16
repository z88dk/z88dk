; void sms_border(uchar colour)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_border

EXTERN asm_sms_border

_sms_border:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_sms_border
