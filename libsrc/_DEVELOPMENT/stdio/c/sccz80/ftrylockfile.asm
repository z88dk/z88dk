
; int ftrylockfile (FILE *stream)

SECTION seg_code_stdio

PUBLIC ftrylockfile

ftrylockfile:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_ftrylockfile.asm"
