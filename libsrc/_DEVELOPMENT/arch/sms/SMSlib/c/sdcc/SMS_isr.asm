; void SMS_isr(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_isr

EXTERN asm_SMSlib_isr

defc _SMS_isr = asm_SMSlib_isr
