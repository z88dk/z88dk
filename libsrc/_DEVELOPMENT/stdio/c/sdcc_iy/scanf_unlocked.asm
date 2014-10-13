
; int scanf_unlocked(const char *format, ...)

SECTION seg_code_stdio

PUBLIC _scanf_unlocked

_scanf_unlocked:

   INCLUDE "stdio/z80/asm_scanf_unlocked.asm"
