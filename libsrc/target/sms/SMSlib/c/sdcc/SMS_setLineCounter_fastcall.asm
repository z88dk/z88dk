; void SMS_setLineCounter(unsigned char count)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setLineCounter_fastcall

EXTERN asm_SMSlib_setLineCounter

defc _SMS_setLineCounter_fastcall = asm_SMSlib_setLineCounter
