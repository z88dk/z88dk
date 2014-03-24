
; void clearerr(FILE *stream)

XDEF clearerr

clearerr:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_clearerr.asm"
