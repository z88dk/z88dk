
; int fflush_unlocked(FILE *stream)

XDEF fflush_unlocked

fflush_unlocked:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fflush_unlocked.asm"
