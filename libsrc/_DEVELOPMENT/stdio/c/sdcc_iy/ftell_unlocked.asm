
; unsigned long ftell_unlocked(FILE *stream)

XDEF ftell_unlocked

ftell_unlocked:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_ftell_unlocked.asm"
