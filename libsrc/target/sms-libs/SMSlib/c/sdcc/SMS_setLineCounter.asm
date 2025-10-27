; void SMS_setLineCounter(unsigned char count)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setLineCounter

EXTERN asm_SMSlib_setLineCounter

_SMS_setLineCounter:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_SMSlib_setLineCounter
