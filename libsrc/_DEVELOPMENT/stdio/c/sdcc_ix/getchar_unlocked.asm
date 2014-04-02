
; int getchar_unlocked(void)

XDEF _getchar_unlocked

_getchar_unlocked:

   push ix
   
   call asm_getchar_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_getchar_unlocked.asm"
