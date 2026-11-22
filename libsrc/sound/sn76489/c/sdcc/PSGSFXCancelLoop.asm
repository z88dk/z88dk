; void PSGSFXCancelLoop(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGSFXCancelLoop

EXTERN asm_PSGlib_CancelLoop

defc _PSGSFXCancelLoop = asm_PSGlib_CancelLoop
