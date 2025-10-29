; void SMS_setBGScrollY(unsigned char scrollY)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setBGScrollY

EXTERN asm_SMSlib_setBGScrollY

_SMS_setBGScrollY:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_SMSlib_setBGScrollY
