; void SMS_isr(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_isr

EXTERN asm_SMSlib_isr

defc SMS_isr = asm_SMSlib_isr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_isr
defc _SMS_isr = SMS_isr
ENDIF

