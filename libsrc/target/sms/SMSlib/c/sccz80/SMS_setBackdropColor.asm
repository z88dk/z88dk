; void SMS_setBackdropColor(unsigned char entry)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_setBackdropColor

EXTERN asm_SMSlib_setBackdropColor

defc SMS_setBackdropColor = asm_SMSlib_setBackdropColor

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_setBackdropColor
defc _SMS_setBackdropColor = SMS_setBackdropColor
ENDIF

