
; int fgetpos(FILE *stream, fpos_t *pos)

XDEF fgetpos_callee

fgetpos_callee:

   pop af
   pop hl
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_fgetpos.asm"
