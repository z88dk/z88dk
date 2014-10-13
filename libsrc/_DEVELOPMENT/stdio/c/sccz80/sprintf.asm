
; int sprintf(char *s, const char *format, ...)

SECTION seg_code_stdio

PUBLIC sprintf

sprintf:

   INCLUDE "stdio/z80/asm_sprintf.asm"
