; unsigned char PSGGetStatus(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGGetStatus

EXTERN asm_PSGlib_GetStatus

defc PSGGetStatus = asm_PSGlib_GetStatus
