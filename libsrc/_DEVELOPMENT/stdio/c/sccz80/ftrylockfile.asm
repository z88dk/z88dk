
; int ftrylockfile (FILE *stream)

PUBLIC ftrylockfile

ftrylockfile:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_ftrylockfile.asm"
