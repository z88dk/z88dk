
; int obstack_vprintf(struct obstack *obstack, const char *format, void *arg)

SECTION code_stdio

PUBLIC obstack_vprintf_callee

obstack_vprintf_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_obstack_vprintf.asm"
