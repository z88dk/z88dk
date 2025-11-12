; unsigned int SMS_getKeysHeld(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_getKeysHeld

EXTERN asm_SMSlib_getKeysHeld

defc _SMS_getKeysHeld = asm_SMSlib_getKeysHeld
