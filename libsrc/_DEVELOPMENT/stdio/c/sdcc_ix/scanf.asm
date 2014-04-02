
; int scanf(const char *format, ...)

XDEF _scanf

_scanf:

   push ix
   
   call asm_scanf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_scanf.asm"
