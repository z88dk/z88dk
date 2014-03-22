
; int scanf_unlocked(const char *format, ...)

XDEF scanf_unlocked

scanf_unlocked:

   push ix
   
   call asm_scanf_unlocked
   
   pop ix
   ret

   INCLUDE "../../z80/asm_scanf_unlocked.asm"
