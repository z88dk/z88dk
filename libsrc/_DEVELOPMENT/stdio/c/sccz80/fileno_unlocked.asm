
; int fileno_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC fileno_unlocked

fileno_unlocked:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_fileno_unlocked.asm"
