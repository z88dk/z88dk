
; int obstack_vprintf(struct obstack *obstack, const char *format, void *arg)

XDEF obstack_vprintf

obstack_vprintf:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_obstack_vprintf.asm"
