; void SMS_setLineCounter(unsigned char count)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_setLineCounter

EXTERN asm_SMSlib_setLineCounter

defc SMS_setLineCounter = asm_SMSlib_setLineCounter
