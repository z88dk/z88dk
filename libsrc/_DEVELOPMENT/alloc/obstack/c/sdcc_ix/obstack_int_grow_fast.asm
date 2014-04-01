
; void *obstack_int_grow_fast(struct obstack *ob, int data)

XDEF obstack_int_grow_fast

obstack_int_grow_fast:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_int_grow_fast.asm"
