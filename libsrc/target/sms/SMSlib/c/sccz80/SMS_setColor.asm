; void SMS_setColor(unsigned char color)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_setColor

EXTERN asm_SMSlib_setColor

defc SMS_setColor = asm_SMSlib_setColor

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_setColor
defc _SMS_setColor = SMS_setColor
ENDIF

