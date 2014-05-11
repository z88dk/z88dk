
; int fgetc_unlocked(FILE *stream)

PUBLIC fgetc_unlocked

fgetc_unlocked:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_fgetc_unlocked.asm"
