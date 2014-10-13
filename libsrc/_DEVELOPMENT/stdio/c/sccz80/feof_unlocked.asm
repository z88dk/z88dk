
; int feof_unlocked(FILE *stream)

SECTION seg_code_stdio

PUBLIC feof_unlocked

feof_unlocked:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_feof_unlocked.asm"
