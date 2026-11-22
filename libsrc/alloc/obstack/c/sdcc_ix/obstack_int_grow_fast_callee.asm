
; void *obstack_int_grow_fast_callee(struct obstack *ob, int data)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_int_grow_fast_callee

EXTERN asm_obstack_int_grow_fast

_obstack_int_grow_fast_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_obstack_int_grow_fast
