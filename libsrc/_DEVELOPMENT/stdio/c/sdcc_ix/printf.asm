
; int printf(const char *format, ...)

XDEF _printf

_printf:

   push ix
   
   call asm_printf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_printf.asm"
