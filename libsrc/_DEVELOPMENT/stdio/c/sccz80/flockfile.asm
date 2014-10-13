
; void flockfile(FILE *file)

SECTION seg_code_stdio

PUBLIC flockfile

flockfile:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_flockfile.asm"
