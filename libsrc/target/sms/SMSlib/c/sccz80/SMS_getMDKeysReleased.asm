; unsigned int SMS_getMDKeysReleased(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getMDKeysReleased

EXTERN asm_SMSlib_getMDKeysReleased

defc SMS_getMDKeysReleased = asm_SMSlib_getMDKeysReleased

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_getMDKeysReleased
defc _SMS_getMDKeysReleased = SMS_getMDKeysReleased
ENDIF

