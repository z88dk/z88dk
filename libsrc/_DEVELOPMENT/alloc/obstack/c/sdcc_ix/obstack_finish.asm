
; void *obstack_finish(struct obstack *ob)

XDEF obstack_finish

obstack_finish:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/obstack/z80/asm_obstack_finish.asm"
