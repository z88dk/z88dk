
; int getc(FILE *stream)

XDEF getc

LIB fgetc

defc getc = fgetc

INCLUDE "../../z80/asm_getc.asm"
