; unsigned char PSGGetStatus(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGGetStatus

EXTERN asm_PSGlib_GetStatus

defc _PSGGetStatus = asm_PSGlib_GetStatus
