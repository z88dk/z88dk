
; int getc_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC getc_unlocked

EXTERN fgetc_unlocked

defc getc_unlocked = fgetc_unlocked
