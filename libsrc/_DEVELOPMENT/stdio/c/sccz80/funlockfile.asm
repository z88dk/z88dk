
; void funlockfile(FILE *file)

SECTION code_stdio

PUBLIC funlockfile

funlockfile:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_funlockfile.asm"
