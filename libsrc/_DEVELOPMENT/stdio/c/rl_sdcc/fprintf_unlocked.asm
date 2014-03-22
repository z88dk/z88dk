
; int fprintf_unlocked(FILE *stream, const char *format, ...)

XDEF fprintf_unlocked

fprintf_unlocked:

   push ix
   
   call asm_fprintf_unlocked
   
   pop ix
   ret

   INCLUDE "../../z80/asm_fprintf_unlocked.asm"
