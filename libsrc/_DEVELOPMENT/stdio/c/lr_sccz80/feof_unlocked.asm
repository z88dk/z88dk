
; int feof_unlocked(FILE *stream)

XDEF feof_unlocked

feof_unlocked:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_feof_unlocked.asm"
