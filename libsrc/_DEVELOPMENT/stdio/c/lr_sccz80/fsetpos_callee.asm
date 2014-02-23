
; int fsetpos(FILE *stream, const fpos_t *pos)

XDEF fsetpos_callee

fsetpos_callee:

   pop af
   pop hl
   pop ix
   push af
   
   INCLUDE "../../z80/asm_fsetpos.asm"
