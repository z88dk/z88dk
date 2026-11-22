; unsigned char PSGGetStatus(void)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGGetStatus

EXTERN asm_PSGlib_GetStatus

defc PSGGetStatus = asm_PSGlib_GetStatus

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _PSGGetStatus
defc _PSGGetStatus = PSGGetStatus
ENDIF

