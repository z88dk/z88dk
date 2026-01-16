; void PSGPlayNoRepeat(void *song)

SECTION code_clib
SECTION code_PSGlib

PUBLIC PSGPlayNoRepeat

EXTERN asm_PSGlib_PlayNoRepeat

defc PSGPlayNoRepeat = asm_PSGlib_PlayNoRepeat

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _PSGPlayNoRepeat
defc _PSGPlayNoRepeat = PSGPlayNoRepeat
ENDIF

