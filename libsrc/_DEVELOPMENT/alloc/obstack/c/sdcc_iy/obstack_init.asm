
; void *obstack_init(struct obstack *ob, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_init

EXTERN asm_obstack_init

_obstack_init:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_obstack_init
