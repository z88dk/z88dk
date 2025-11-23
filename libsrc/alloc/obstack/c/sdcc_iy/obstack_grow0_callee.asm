
; int obstack_grow0_callee(struct obstack *ob, void *data, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_grow0_callee

EXTERN asm_obstack_grow0

_obstack_grow0_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_obstack_grow0
