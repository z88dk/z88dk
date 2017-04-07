; unsigned char SMS_getHCount(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getHCount

EXTERN asm_SMSlib_getHCount

defc SMS_getHCount = asm_SMSlib_getHCount
