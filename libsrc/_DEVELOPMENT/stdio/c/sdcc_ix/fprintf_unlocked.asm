
; int fprintf_unlocked(FILE *stream, const char *format, ...)

PUBLIC _fprintf_unlocked

_fprintf_unlocked:

   push ix
   
   call asm_fprintf_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_fprintf_unlocked.asm"
