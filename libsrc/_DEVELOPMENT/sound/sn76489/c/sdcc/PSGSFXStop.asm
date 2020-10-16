; void PSGSFXStop(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGSFXStop

EXTERN asm_PSGlib_SFXStop

defc _PSGSFXStop = asm_PSGlib_SFXStop
