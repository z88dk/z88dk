
; void *obstack_init(struct obstack *ob, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_init

EXTERN asm_obstack_init

obstack_init:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_obstack_init
