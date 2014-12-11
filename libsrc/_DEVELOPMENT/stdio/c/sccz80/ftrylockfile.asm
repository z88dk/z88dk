
; int ftrylockfile (FILE *stream)

SECTION code_stdio

PUBLIC ftrylockfile

ftrylockfile:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_ftrylockfile.asm"
