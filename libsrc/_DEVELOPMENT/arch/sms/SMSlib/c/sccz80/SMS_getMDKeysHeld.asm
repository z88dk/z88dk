; unsigned int SMS_getMDKeysHeld(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_getMDKeysHeld

EXTERN asm_SMSlib_getMDKeysHeld

defc SMS_getMDKeysHeld = asm_SMSlib_getMDKeysHeld
