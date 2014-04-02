
; int getc_unlocked(FILE *stream)

XDEF _getc_unlocked

LIB _fgetc_unlocked

_getc_unlocked:

   jp _fgetc_unlocked

   INCLUDE "stdio/z80/asm_getc_unlocked.asm"
