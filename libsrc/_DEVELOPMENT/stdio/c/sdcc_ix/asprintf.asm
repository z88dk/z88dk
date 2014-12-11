 
; int asprintf (char **ptr, const char *format, ...)

SECTION code_stdio

PUBLIC _asprintf

_asprintf:

   push ix
   
   call asm_asprintf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_asprintf.asm"
