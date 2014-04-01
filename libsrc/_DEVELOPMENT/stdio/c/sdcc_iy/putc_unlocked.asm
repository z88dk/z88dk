
; int putc_unlocked(int c, FILE *stream)

XDEF putc_unlocked

LIB fputc_unlocked

putc_unlocked:

   jp fputc_unlocked

   INCLUDE "stdio/z80/asm_putc_unlocked.asm"
