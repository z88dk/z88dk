
; int getc_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _getc_unlocked

EXTERN _fgetc_unlocked

defc _getc_unlocked = _fgetc_unlocked
