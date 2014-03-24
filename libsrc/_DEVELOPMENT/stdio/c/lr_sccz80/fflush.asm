
; int fflush(FILE *stream)

XDEF fflush

fflush:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_fflush.asm"
