
; int fgetc(FILE *stream)

XDEF fgetc

fgetc:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_fgetc.asm"
