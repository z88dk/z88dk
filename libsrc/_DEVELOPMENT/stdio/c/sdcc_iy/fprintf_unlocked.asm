
; int fprintf_unlocked(FILE *stream, const char *format, ...)

SECTION code_stdio

PUBLIC _fprintf_unlocked

_fprintf_unlocked:

   INCLUDE "stdio/z80/asm_fprintf_unlocked.asm"
