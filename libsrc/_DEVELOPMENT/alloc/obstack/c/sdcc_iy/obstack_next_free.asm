
; void *obstack_next_free(struct obstack *ob)

XDEF obstack_next_free

obstack_next_free:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/obstack/z80/asm_obstack_next_free.asm"
