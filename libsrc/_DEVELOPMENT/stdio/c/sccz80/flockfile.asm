
; void flockfile(FILE *file)

PUBLIC flockfile

flockfile:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_flockfile.asm"
