; unsigned char SMS_getVCount(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getVCount

EXTERN asm_SMSlib_getVCount

defc SMS_getVCount = asm_SMSlib_getVCount

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_getVCount
defc _SMS_getVCount = SMS_getVCount
ENDIF

