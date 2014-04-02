
; void clearerr(FILE *stream)

XDEF _clearerr

_clearerr:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_clearerr.asm"
