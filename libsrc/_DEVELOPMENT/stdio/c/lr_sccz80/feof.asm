
; int feof(FILE *stream)

XDEF feof

feof:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_feof.asm"
