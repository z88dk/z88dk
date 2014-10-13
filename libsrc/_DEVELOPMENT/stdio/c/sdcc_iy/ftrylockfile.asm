
; int ftrylockfile (FILE *stream)

SECTION seg_code_stdio

PUBLIC _ftrylockfile

_ftrylockfile:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_ftrylockfile.asm"
