
; void flockfile(FILE *file)

SECTION code_stdio

PUBLIC _flockfile

_flockfile:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_flockfile.asm"
