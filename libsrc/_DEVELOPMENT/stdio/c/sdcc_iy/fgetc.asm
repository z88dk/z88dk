
; int fgetc(FILE *stream)

XDEF fgetc

fgetc:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fgetc.asm"
