; void PSGSFXCancelLoop(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGSFXCancelLoop

EXTERN asm_PSGlib_CancelLoop

defc PSGSFXCancelLoop = asm_PSGlib_CancelLoop

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _PSGSFXCancelLoop
defc _PSGSFXCancelLoop = PSGSFXCancelLoop
ENDIF

