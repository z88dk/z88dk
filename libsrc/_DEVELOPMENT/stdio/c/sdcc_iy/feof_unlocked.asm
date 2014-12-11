
; int feof_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC _feof_unlocked

_feof_unlocked:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_feof_unlocked.asm"
