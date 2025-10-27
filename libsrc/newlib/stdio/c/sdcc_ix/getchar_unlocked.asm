
; int getchar_unlocked(void)

SECTION code_clib
SECTION code_stdio

PUBLIC _getchar_unlocked

EXTERN asm_getchar_unlocked

_getchar_unlocked:

   push ix
   
   call asm_getchar_unlocked
   
   pop ix
   ret
