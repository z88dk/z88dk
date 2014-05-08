
; void *obstack_finish(struct obstack *ob)

PUBLIC _obstack_finish

_obstack_finish:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/obstack/z80/asm_obstack_finish.asm"
