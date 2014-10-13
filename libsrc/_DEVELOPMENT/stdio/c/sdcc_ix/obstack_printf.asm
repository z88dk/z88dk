
; int obstack_printf(struct obstack *obstack, const char *format, ...)

SECTION seg_code_stdio

PUBLIC _obstack_printf

_obstack_printf:

   push ix
   
   call asm_obstack_printf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_obstack_printf.asm"
