
; int ungetc_unlocked(int c, FILE *stream)

XDEF _ungetc_unlocked

_ungetc_unlocked:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_ungetc_unlocked.asm"
