
; int fgetpos_unlocked(FILE *stream, fpos_t *pos)

XDEF fgetpos_unlocked_callee

fgetpos_unlocked_callee:

   pop af
   pop hl
   pop ix
   push af
   
   INCLUDE "../../z80/asm_fgetpos_unlocked.asm"
