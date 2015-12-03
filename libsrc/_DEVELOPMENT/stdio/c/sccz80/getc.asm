
; int getc(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC getc

EXTERN fgetc

defc getc = fgetc
