
; unsigned long ftell_unlocked(FILE *stream)

PUBLIC _ftell_unlocked

_ftell_unlocked:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_ftell_unlocked.asm"
