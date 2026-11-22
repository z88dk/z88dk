; unsigned char SMS_getHCount(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getHCount

EXTERN asm_SMSlib_getHCount

defc SMS_getHCount = asm_SMSlib_getHCount

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_getHCount
defc _SMS_getHCount = SMS_getHCount
ENDIF

