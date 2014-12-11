
; int ferror_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC ferror_unlocked

ferror_unlocked:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_ferror_unlocked.asm"
