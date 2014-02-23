
; void clearerr(FILE *stream)

XDEF clearerr

clearerr:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_clearerr.asm"
