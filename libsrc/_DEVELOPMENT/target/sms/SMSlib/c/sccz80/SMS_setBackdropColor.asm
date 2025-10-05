; void SMS_setBackdropColor(unsigned char entry)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_setBackdropColor

EXTERN asm_SMSlib_setBackdropColor

defc SMS_setBackdropColor = asm_SMSlib_setBackdropColor
