
; int feof(FILE *stream)

XDEF feof

feof:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_feof.asm"
