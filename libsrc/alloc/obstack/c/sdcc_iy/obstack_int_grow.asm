
; void *obstack_int_grow(struct obstack *ob, int data)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_int_grow

EXTERN asm_obstack_int_grow

_obstack_int_grow:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_obstack_int_grow
