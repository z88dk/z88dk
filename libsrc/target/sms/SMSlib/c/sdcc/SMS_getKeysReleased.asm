; unsigned int SMS_getKeysReleased(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_getKeysReleased

EXTERN asm_SMSlib_getKeysReleased

defc _SMS_getKeysReleased = asm_SMSlib_getKeysReleased
