; void PSGFrame(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC _PSGFrame

EXTERN asm_PSGlib_Frame

defc _PSGFrame = asm_PSGlib_Frame
