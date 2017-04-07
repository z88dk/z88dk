; unsigned int SMS_getMDKeysReleased(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_getMDKeysReleased

EXTERN asm_SMSlib_getMDKeysReleased

defc _SMS_getMDKeysReleased = asm_SMSlib_getMDKeysReleased
