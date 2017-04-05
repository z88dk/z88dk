; void SMS_setBGScrollX(unsigned char scrollX)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_setBGScrollX

EXTERN asm_SMSlib_setBGScrollX

defc SMS_setBGScrollX = asm_SMSlib_setBGScrollX
