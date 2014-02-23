
; int ferror_unlocked(FILE *stream)

XDEF ferror_unlocked

ferror_unlocked:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_ferror_unlocked.asm"
