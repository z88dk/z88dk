; void SMS_setColor(unsigned char color)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setColor

EXTERN asm_SMSlib_setColor

_SMS_setColor:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_SMSlib_setColor
