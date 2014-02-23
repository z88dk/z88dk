
; int ftrylockfile (FILE *stream)

XDEF ftrylockfile

ftrylockfile:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_ftrylockfile.asm"
