
; int obstack_vprintf(struct obstack *obstack, const char *format, void *arg)

XDEF obstack_vprintf_callee

obstack_vprintf_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm_obstack_vprintf.asm"
