
; int printf(const char *format, ...)

XDEF printf

printf:

   push ix
   
   call asm_printf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_printf.asm"
