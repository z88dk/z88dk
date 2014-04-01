
; int feof_unlocked(FILE *stream)

XDEF feof_unlocked

feof_unlocked:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_feof_unlocked.asm"
