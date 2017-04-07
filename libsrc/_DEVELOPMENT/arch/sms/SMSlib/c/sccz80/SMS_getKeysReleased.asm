; unsigned int SMS_getKeysReleased(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getKeysReleased

EXTERN asm_SMSlib_getKeysReleased

defc SMS_getKeysReleased = asm_SMSlib_getKeysReleased
