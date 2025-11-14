; unsigned int SMS_getMDKeysPressed(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getMDKeysPressed

EXTERN asm_SMSlib_getMDKeysPressed

defc SMS_getMDKeysPressed = asm_SMSlib_getMDKeysPressed

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_getMDKeysPressed
defc _SMS_getMDKeysPressed = SMS_getMDKeysPressed
ENDIF

