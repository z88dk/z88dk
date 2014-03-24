
; int feof_unlocked(FILE *stream)

XDEF feof_unlocked

feof_unlocked:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_feof_unlocked.asm"
