
; void *obstack_1grow_callee(struct obstack *ob, char c)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_1grow_callee

EXTERN asm_obstack_1grow

_obstack_1grow_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_obstack_1grow
