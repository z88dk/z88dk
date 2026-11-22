; void SMS_setBackdropColor(unsigned char entry)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setBackdropColor

EXTERN asm_SMSlib_setBackdropColor

_SMS_setBackdropColor:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_SMSlib_setBackdropColor
