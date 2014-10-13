
; int fflush_unlocked(FILE *stream)

SECTION seg_code_stdio

PUBLIC _fflush_unlocked

_fflush_unlocked:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fflush_unlocked.asm"
