
; void *obstack_alloc(struct obstack *ob, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_alloc

EXTERN asm_obstack_alloc

obstack_alloc:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_alloc
