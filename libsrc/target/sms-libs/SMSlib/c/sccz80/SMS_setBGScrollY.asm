; void SMS_setBGScrollY(unsigned char scrollY)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_setBGScrollY

EXTERN asm_SMSlib_setBGScrollY

defc SMS_setBGScrollY = asm_SMSlib_setBGScrollY
