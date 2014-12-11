
; int fileno_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC _fileno_unlocked

_fileno_unlocked:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fileno_unlocked.asm"
