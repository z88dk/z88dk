; unsigned int SMS_getMDKeysHeld(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getMDKeysHeld

EXTERN asm_SMSlib_getMDKeysHeld

defc SMS_getMDKeysHeld = asm_SMSlib_getMDKeysHeld

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_getMDKeysHeld
defc _SMS_getMDKeysHeld = SMS_getMDKeysHeld
ENDIF

