; void PSGFrame(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGFrame

EXTERN asm_PSGlib_Frame

defc PSGFrame = asm_PSGlib_Frame

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _PSGFrame
defc _PSGFrame = PSGFrame
ENDIF

