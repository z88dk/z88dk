
; int ungetc_unlocked_callee(int c, FILE *stream)

SECTION code_stdio

PUBLIC _ungetc_unlocked_callee

_ungetc_unlocked_callee:

   pop af
   pop hl
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_ungetc_unlocked.asm"
