
; int putc_unlocked(int c, FILE *stream)

XDEF _putc_unlocked

LIB _fputc_unlocked

_putc_unlocked:

   jp _fputc_unlocked

   INCLUDE "stdio/z80/asm_putc_unlocked.asm"
