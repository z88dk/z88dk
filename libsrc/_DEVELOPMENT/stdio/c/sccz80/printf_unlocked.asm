
; int printf_unlocked(const char *format, ...)

SECTION code_stdio

PUBLIC printf_unlocked

printf_unlocked:

   INCLUDE "stdio/z80/asm_printf_unlocked.asm"
