
; unsigned long ftell_unlocked(FILE *stream)

SECTION seg_code_stdio

PUBLIC ftell_unlocked

ftell_unlocked:

   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_ftell_unlocked.asm"
