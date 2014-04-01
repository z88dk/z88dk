
; int fflush(FILE *stream)

XDEF fflush

fflush:

   pop af
   pop ix
   
   push ix
   push af

   INCLUDE "stdio/z80/asm_fflush.asm"
