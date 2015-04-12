
; void rewind_unlocked_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC rewind_unlocked_fastcall

rewind_unlocked_fastcall:
   
   push hl
   pop ix
   
   INCLUDE "stdio/z80/asm_rewind_unlocked.asm"
