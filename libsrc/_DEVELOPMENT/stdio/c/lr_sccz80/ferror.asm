
; int ferror(FILE *stream)

XDEF ferror

ferror:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_ferror.asm"
