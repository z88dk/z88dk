
; void *obstack_int_grow_fast(struct obstack *ob, int data)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_int_grow_fast

EXTERN asm_obstack_int_grow_fast

_obstack_int_grow_fast:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_obstack_int_grow_fast
