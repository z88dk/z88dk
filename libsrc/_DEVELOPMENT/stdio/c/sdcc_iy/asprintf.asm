 
; int asprintf (char **ptr, const char *format, ...)

SECTION seg_code_stdio

PUBLIC _asprintf

_asprintf:

   INCLUDE "stdio/z80/asm_asprintf.asm"
