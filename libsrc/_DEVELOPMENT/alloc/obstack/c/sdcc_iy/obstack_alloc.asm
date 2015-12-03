
; void *obstack_alloc(struct obstack *ob, size_t size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_alloc

EXTERN asm_obstack_alloc

_obstack_alloc:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_obstack_alloc
