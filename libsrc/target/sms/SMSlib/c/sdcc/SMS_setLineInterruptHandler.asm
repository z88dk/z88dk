; void SMS_setLineInterruptHandler(void *theHandlerFunction)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setLineInterruptHandler

EXTERN asm_SMSlib_setLineInterruptHandler

_SMS_setLineInterruptHandler:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_SMSlib_setLineInterruptHandler
