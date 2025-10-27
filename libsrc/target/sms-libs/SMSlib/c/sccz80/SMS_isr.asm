; void SMS_isr(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_isr

EXTERN asm_SMSlib_isr

defc SMS_isr = asm_SMSlib_isr
