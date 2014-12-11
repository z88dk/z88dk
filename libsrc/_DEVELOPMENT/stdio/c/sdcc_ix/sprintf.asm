
; int sprintf(char *s, const char *format, ...)

SECTION code_stdio

PUBLIC _sprintf

_sprintf:

   push ix
   
   call asm_sprintf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_sprintf.asm"
