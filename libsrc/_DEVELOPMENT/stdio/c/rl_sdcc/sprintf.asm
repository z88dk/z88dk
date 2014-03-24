
; int sprintf(char *s, const char *format, ...)

XDEF sprintf

sprintf:

   push ix
   
   call asm_sprintf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_sprintf.asm"
