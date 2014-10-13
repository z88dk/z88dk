
; void rewind_unlocked(FILE *stream)

SECTION seg_code_stdio

PUBLIC rewind_unlocked

rewind_unlocked:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_rewind_unlocked.asm"
