; unsigned int SMS_getMDKeysPressed(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_getMDKeysPressed

EXTERN asm_SMSlib_getMDKeysPressed

defc _SMS_getMDKeysPressed = asm_SMSlib_getMDKeysPressed
