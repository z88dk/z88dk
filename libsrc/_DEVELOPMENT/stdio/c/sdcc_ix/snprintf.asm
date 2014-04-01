
; int snprintf(char *s, size_t n, const char *format, ...)

XDEF snprintf

snprintf:

   push ix
   
   call asm_snprintf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_snprintf.asm"
