
; int putc(int c, FILE *stream)

XDEF _putc

LIB _fputc

_putc:

   jp _fputc

   INCLUDE "stdio/z80/asm_putc.asm"
