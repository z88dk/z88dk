
; int printf_unlocked(const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC _printf_unlocked

EXTERN asm_printf_unlocked

_printf_unlocked:

   push ix
   
   call asm_printf_unlocked
   
   pop ix
   ret
