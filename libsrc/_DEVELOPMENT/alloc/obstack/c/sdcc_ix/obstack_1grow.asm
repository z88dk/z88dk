
; void *obstack_1grow(struct obstack *ob, char c)

XDEF obstack_1grow

obstack_1grow:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_1grow.asm"
