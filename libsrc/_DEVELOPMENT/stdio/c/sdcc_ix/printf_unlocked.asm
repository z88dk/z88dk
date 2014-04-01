
; int printf_unlocked(const char *format, ...)

XDEF printf_unlocked

printf_unlocked:

   push ix
   
   call asm_printf_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_printf_unlocked.asm"
