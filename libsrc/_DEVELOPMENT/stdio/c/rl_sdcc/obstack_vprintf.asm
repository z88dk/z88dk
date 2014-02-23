
; int obstack_vprintf(struct obstack *obstack, const char *format, void *arg)

XDEF obstack_vprintf

obstack_vprintf:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_obstack_vprintf.asm"
