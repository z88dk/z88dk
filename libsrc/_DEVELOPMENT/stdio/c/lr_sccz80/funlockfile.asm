
; void funlockfile(FILE *file)

XDEF funlockfile

funlockfile:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_funlockfile.asm"
