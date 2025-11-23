
; int obstack_printf(struct obstack *obstack, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC _obstack_printf

EXTERN asm_obstack_printf

_obstack_printf:

   push ix
   
   call asm_obstack_printf
   
   pop ix
   ret
