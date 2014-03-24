
; int getc(FILE *stream)

XDEF getc

LIB fgetc

defc getc = fgetc

INCLUDE "stdio/z80/asm_getc.asm"
