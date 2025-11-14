
; int obstack_grow_callee(struct obstack *ob, void *data, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_grow_callee

EXTERN asm_obstack_grow

_obstack_grow_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_obstack_grow
