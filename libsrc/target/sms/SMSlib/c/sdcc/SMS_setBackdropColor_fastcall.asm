; void SMS_setBackdropColor(unsigned char entry)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setBackdropColor_fastcall

EXTERN asm_SMSlib_setBackdropColor

defc _SMS_setBackdropColor_fastcall = asm_SMSlib_setBackdropColor
