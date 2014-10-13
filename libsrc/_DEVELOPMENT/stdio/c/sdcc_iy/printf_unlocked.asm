
; int printf_unlocked(const char *format, ...)

SECTION seg_code_stdio

PUBLIC _printf_unlocked

_printf_unlocked:
   
   INCLUDE "stdio/z80/asm_printf_unlocked.asm"
