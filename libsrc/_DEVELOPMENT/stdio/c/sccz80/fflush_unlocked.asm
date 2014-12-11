
; int fflush_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC fflush_unlocked

fflush_unlocked:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_fflush_unlocked.asm"
