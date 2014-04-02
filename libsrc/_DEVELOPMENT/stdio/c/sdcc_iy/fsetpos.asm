
; int fsetpos(FILE *stream, const fpos_t *pos)

XDEF _fsetpos

_fsetpos:

   pop af
   pop ix
   pop hl
   
   push hl
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fsetpos.asm"
