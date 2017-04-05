; unsigned int SMS_getMDKeysStatus(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_getMDKeysStatus

EXTERN asm_SMSlib_getMDKeysStatus

defc _SMS_getMDKeysStatus = asm_SMSlib_getMDKeysStatus
