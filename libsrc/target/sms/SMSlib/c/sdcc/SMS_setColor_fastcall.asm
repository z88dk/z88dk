; void SMS_setColor(unsigned char color)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setColor_fastcall

EXTERN asm_SMSlib_setColor

defc _SMS_setColor_fastcall = asm_SMSlib_setColor
