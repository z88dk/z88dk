
; void *obstack_alloc_callee(struct obstack *ob, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_alloc_callee

EXTERN asm_obstack_alloc

_obstack_alloc_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_obstack_alloc
