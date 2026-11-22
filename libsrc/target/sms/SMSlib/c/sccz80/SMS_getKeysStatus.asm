; unsigned int SMS_getKeysStatus(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getKeysStatus

EXTERN asm_SMSlib_getKeysStatus

defc SMS_getKeysStatus = asm_SMSlib_getKeysStatus

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_getKeysStatus
defc _SMS_getKeysStatus = SMS_getKeysStatus
ENDIF

