
; int fgetc(FILE *stream)

XDEF fgetc, getc

fgetc:
getc:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_fgetc.asm"
