; void SMS_setBGScrollX(unsigned char scrollX)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setBGScrollX

EXTERN asm_SMSlib_setBGScrollX

_SMS_setBGScrollX:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_SMSlib_setBGScrollX
