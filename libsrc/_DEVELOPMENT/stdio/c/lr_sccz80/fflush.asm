
; int fflush(FILE *stream)

XDEF fflush

fflush:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_fflush.asm"
