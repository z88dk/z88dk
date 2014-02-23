
; unsigned long ftell_unlocked(FILE *stream)

XDEF ftell_unlocked

ftell_unlocked:

   push hl
   pop ix
   
   INCLUDE "../../z80/asm_ftell_unlocked.asm"
