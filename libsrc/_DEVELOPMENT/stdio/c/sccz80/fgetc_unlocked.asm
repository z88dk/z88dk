
; int fgetc_unlocked(FILE *stream)

SECTION seg_code_stdio

PUBLIC fgetc_unlocked

fgetc_unlocked:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_fgetc_unlocked.asm"
