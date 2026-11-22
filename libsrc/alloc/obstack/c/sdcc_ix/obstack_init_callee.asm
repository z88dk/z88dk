
; void *obstack_init_callee(struct obstack *ob, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_init_callee

EXTERN asm_obstack_init

_obstack_init_callee:

   pop af
   pop de
   pop bc
   push af
   
   jp asm_obstack_init
