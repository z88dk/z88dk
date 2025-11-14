; unsigned int SMS_getKeysPressed(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getKeysPressed

EXTERN asm_SMSlib_getKeysPressed

defc SMS_getKeysPressed = asm_SMSlib_getKeysPressed

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_getKeysPressed
defc _SMS_getKeysPressed = SMS_getKeysPressed
ENDIF

