; unsigned int SMS_getKeysHeld(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getKeysHeld

EXTERN asm_SMSlib_getKeysHeld

defc SMS_getKeysHeld = asm_SMSlib_getKeysHeld

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_getKeysHeld
defc _SMS_getKeysHeld = SMS_getKeysHeld
ENDIF

