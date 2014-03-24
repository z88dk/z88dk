
; int getc(FILE *stream)

XDEF getc

LIB fgetc

;defc getc = fgetc

getc:

   jp fgetc

INCLUDE "stdio/z80/asm_getc.asm"
