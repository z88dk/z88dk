
; int fgetc(FILE *stream)

XDEF fgetc

fgetc:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_fgetc.asm"
