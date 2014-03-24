 
; int asprintf (char **ptr, const char *format, ...)

XDEF asprintf

asprintf:

   push ix
   
   call asm_asprintf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_asprintf.asm"
