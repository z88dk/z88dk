
; void flockfile(FILE *file)

XDEF flockfile

flockfile:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_flockfile.asm"
