
; int getc(FILE *stream)

PUBLIC getc

EXTERN fgetc

;defc getc = fgetc

getc:

   jp fgetc

INCLUDE "stdio/z80/asm_getc.asm"
