
; int obstack_printf(struct obstack *obstack, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC obstack_printf

EXTERN asm_obstack_printf

defc obstack_printf = asm_obstack_printf
