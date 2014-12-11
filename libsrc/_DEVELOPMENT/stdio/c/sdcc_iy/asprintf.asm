 
; int asprintf (char **ptr, const char *format, ...)

SECTION code_stdio

PUBLIC _asprintf

_asprintf:

   INCLUDE "stdio/z80/asm_asprintf.asm"
