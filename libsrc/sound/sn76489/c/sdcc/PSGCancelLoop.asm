; void PSGCancelLoop(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGCancelLoop

EXTERN asm_PSGlib_SFXCancelLoop

defc _PSGCancelLoop = asm_PSGlib_SFXCancelLoop
