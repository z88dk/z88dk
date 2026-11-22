; unsigned char SMS_getVCount(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_getVCount

EXTERN asm_SMSlib_getVCount

defc _SMS_getVCount = asm_SMSlib_getVCount
