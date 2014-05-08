
; int ferror_unlocked(FILE *stream)

PUBLIC ferror_unlocked

ferror_unlocked:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_ferror_unlocked.asm"
