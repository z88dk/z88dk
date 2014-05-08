
; int fclose_unlocked(FILE *stream)

PUBLIC fclose_unlocked

fclose_unlocked:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_fclose_unlocked.asm"
