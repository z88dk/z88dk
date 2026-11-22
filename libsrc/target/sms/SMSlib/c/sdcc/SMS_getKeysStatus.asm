; unsigned int SMS_getKeysStatus(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_getKeysStatus

EXTERN asm_SMSlib_getKeysStatus

defc _SMS_getKeysStatus = asm_SMSlib_getKeysStatus
