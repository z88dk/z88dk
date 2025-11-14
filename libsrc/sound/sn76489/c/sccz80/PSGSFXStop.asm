; void PSGSFXStop(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGSFXStop

EXTERN asm_PSGlib_SFXStop

defc PSGSFXStop = asm_PSGlib_SFXStop

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _PSGSFXStop
defc _PSGSFXStop = PSGSFXStop
ENDIF

