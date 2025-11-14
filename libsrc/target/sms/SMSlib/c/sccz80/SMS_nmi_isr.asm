; void SMS_nmi_isr(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_nmi_isr

EXTERN asm_SMSlib_nmi_isr

defc SMS_nmi_isr = asm_SMSlib_nmi_isr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_nmi_isr
defc _SMS_nmi_isr = SMS_nmi_isr
ENDIF

