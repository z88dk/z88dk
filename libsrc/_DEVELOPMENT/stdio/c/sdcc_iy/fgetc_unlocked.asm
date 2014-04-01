
; int fgetc_unlocked(FILE *stream)

XDEF fgetc_unlocked

fgetc_unlocked:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fgetc_unlocked.asm"
