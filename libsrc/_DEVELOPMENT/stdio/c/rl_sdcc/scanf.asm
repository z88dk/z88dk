
; int scanf(const char *format, ...)

XDEF scanf

scanf:

   push ix
   
   call asm_scanf
   
   pop ix
   ret

   INCLUDE "../../z80/asm_scanf.asm"
