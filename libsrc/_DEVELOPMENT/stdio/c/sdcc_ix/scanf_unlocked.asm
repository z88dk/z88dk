
; int scanf_unlocked(const char *format, ...)

XDEF _scanf_unlocked

_scanf_unlocked:

   push ix
   
   call asm_scanf_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_scanf_unlocked.asm"
