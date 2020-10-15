; void PSGSFXFrame(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGSFXFrame

EXTERN asm_PSGlib_SFXFrame

defc _PSGSFXFrame = asm_PSGlib_SFXFrame
