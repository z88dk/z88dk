
; void *obstack_int_grow(struct obstack *ob, int data)

XDEF obstack_int_grow

obstack_int_grow:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_int_grow.asm"
