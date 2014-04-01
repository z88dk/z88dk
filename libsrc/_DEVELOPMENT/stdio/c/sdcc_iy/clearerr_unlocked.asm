
; void clearerr_unlocked(FILE *stream)

XDEF clearerr_unlocked

clearerr_unlocked:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_clearerr_unlocked.asm"
