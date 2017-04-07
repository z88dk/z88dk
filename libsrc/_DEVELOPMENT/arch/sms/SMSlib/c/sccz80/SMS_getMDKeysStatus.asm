; unsigned int SMS_getMDKeysStatus(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getMDKeysStatus

EXTERN asm_SMSlib_getMDKeysStatus

defc SMS_getMDKeysStatus = asm_SMSlib_getMDKeysStatus
