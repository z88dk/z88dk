
; int getc(FILE *stream)

SECTION code_stdio

PUBLIC getc

EXTERN fgetc

defc getc = fgetc
