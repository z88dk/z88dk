
; int scanf_unlocked(const char *format, ...)

SECTION code_stdio

PUBLIC scanf_unlocked

scanf_unlocked:

   INCLUDE "stdio/z80/asm_scanf_unlocked.asm"
