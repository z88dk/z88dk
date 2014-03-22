
; int fgetc_unlocked(FILE *stream)

XDEF fgetc_unlocked

fgetc_unlocked:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_fgetc_unlocked.asm"
