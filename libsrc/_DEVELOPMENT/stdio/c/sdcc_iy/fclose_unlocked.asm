
; int fclose_unlocked(FILE *stream)

PUBLIC _fclose_unlocked

_fclose_unlocked:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fclose_unlocked.asm"
