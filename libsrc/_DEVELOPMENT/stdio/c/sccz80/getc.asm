
; int getc(FILE *stream)

SECTION seg_code_stdio

PUBLIC getc

EXTERN fgetc

defc getc = fgetc

INCLUDE "stdio/z80/asm_getc.asm"
