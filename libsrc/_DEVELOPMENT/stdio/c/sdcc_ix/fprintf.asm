
; int fprintf(FILE *stream, const char *format, ...)

XDEF _fprintf

_fprintf:

   push ix
   
   call asm_fprintf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_fprintf.asm"
