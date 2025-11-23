; unsigned char PSGSFXGetStatus(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGSFXGetStatus

EXTERN asm_PSGlib_SFXGetStatus

defc _PSGSFXGetStatus = asm_PSGlib_SFXGetStatus
