
; int getchar_unlocked(void)

XDEF getchar_unlocked

getchar_unlocked:

   push ix
   
   call asm_getchar_unlocked
   
   pop ix
   ret

   INCLUDE "../../z80/asm_getchar_unlocked.asm"
