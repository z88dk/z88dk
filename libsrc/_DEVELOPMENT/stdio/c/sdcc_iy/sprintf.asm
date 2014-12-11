
; int sprintf(char *s, const char *format, ...)

SECTION code_stdio

PUBLIC _sprintf

_sprintf:

   INCLUDE "stdio/z80/asm_sprintf.asm"
