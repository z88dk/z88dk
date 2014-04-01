
; int fsetpos_unlocked(FILE *stream, const fpos_t *pos)

XDEF fsetpos_unlocked

fsetpos_unlocked:

   pop af
   pop ix
   pop hl
   
   push hl
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fsetpos_unlocked.asm"
