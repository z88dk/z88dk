
; int ferror(FILE *stream)

XDEF _ferror

_ferror:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_ferror.asm"
