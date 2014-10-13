
; int snprintf(char *s, size_t n, const char *format, ...)

SECTION seg_code_stdio

PUBLIC _snprintf

_snprintf:

   INCLUDE "stdio/z80/asm_snprintf.asm"
