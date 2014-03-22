
; int ferror(FILE *stream)

XDEF ferror

ferror:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_ferror.asm"
