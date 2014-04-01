
; int putc(int c, FILE *stream)

XDEF putc

LIB fputc

putc:

   jp fputc

   INCLUDE "stdio/z80/asm_putc.asm"
