
; char *gets_unlocked_fastcall(char *s)

SECTION code_stdio

PUBLIC _gets_unlocked_fastcall

_gets_unlocked_fastcall:

   push ix
   
   call asm_gets_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_gets_unlocked.asm"
