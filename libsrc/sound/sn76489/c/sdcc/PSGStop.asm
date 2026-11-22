; void PSGStop(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGStop

EXTERN asm_PSGlib_Stop

defc _PSGStop = asm_PSGlib_Stop
