
; int scanf_unlocked(const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC _scanf_unlocked

EXTERN asm_scanf_unlocked

_scanf_unlocked:

   push ix
   
   call asm_scanf_unlocked
   
   pop ix
   ret
