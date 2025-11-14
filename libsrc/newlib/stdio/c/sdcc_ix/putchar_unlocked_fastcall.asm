
; int putchar_unlocked_fastcall(int c)

SECTION code_clib
SECTION code_stdio

PUBLIC _putchar_unlocked_fastcall

EXTERN asm_putchar_unlocked

_putchar_unlocked_fastcall:

   push ix
   
   call asm_putchar_unlocked
   
   pop ix
   ret
