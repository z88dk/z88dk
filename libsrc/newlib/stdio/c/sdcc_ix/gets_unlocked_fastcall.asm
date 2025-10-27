
; char *gets_unlocked_fastcall(char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC _gets_unlocked_fastcall

EXTERN asm_gets_unlocked

_gets_unlocked_fastcall:

   push ix
   
   call asm_gets_unlocked
   
   pop ix
   ret
