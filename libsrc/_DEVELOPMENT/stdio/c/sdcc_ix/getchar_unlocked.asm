
; int getchar_unlocked(void)

PUBLIC _getchar_unlocked

_getchar_unlocked:

   push ix
   
   call asm_getchar_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_getchar_unlocked.asm"
