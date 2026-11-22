
; void *obstack_free_callee(struct obstack *ob, void *object)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_free_callee

EXTERN asm_obstack_free

_obstack_free_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_obstack_free
