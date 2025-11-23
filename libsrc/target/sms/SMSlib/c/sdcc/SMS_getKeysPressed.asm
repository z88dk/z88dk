; unsigned int SMS_getKeysPressed(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_getKeysPressed

EXTERN asm_SMSlib_getKeysPressed

defc _SMS_getKeysPressed = asm_SMSlib_getKeysPressed
