
; int ftrylockfile (FILE *stream)

XDEF ftrylockfile

ftrylockfile:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_ftrylockfile.asm"
