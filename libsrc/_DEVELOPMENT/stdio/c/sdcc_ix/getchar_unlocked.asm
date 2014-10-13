
; int getchar_unlocked(void)

SECTION seg_code_stdio

PUBLIC _getchar_unlocked

_getchar_unlocked:

   push ix
   
   call asm_getchar_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_getchar_unlocked.asm"
