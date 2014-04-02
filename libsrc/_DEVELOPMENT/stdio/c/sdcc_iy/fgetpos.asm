
; int fgetpos(FILE *stream, fpos_t *pos)

XDEF _fgetpos

_fgetpos:

   pop af
   pop ix
   pop hl
   
   push hl
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fgetpos.asm"
