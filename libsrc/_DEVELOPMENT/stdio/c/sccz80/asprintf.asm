 
; int asprintf (char **ptr, const char *format, ...)

SECTION code_stdio

PUBLIC asprintf

asprintf:

   INCLUDE "stdio/z80/asm_asprintf.asm"
