
; int fflush_unlocked(FILE *stream)

XDEF fflush_unlocked

fflush_unlocked:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_fflush_unlocked.asm"
