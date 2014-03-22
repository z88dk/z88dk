
; void flockfile(FILE *file)

XDEF flockfile

flockfile:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_flockfile.asm"
