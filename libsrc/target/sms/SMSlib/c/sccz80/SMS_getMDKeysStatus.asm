; unsigned int SMS_getMDKeysStatus(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getMDKeysStatus

EXTERN asm_SMSlib_getMDKeysStatus

defc SMS_getMDKeysStatus = asm_SMSlib_getMDKeysStatus

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_getMDKeysStatus
defc _SMS_getMDKeysStatus = SMS_getMDKeysStatus
ENDIF

