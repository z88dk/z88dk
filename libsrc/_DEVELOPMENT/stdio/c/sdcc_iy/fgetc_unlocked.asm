
; int fgetc_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC _fgetc_unlocked

_fgetc_unlocked:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fgetc_unlocked.asm"
