
; void *obstack_int_grow_fast_callee(struct obstack *ob, int data)

SECTION code_alloc_obstack

PUBLIC _obstack_int_grow_fast_callee

_obstack_int_grow_fast_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_int_grow_fast.asm"
