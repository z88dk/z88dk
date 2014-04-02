
; int printf_unlocked(const char *format, ...)

XDEF _printf_unlocked

_printf_unlocked:

   push ix
   
   call asm_printf_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_printf_unlocked.asm"
