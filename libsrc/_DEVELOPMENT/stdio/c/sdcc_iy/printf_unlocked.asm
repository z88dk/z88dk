
; int printf_unlocked(const char *format, ...)

SECTION code_stdio

PUBLIC _printf_unlocked

_printf_unlocked:
   
   INCLUDE "stdio/z80/asm_printf_unlocked.asm"
