
; int snprintf(char *s, size_t n, const char *format, ...)

SECTION code_stdio

PUBLIC snprintf

snprintf:

   INCLUDE "stdio/z80/asm_snprintf.asm"
