
; void *obstack_next_free(struct obstack *ob)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_next_free

EXTERN asm_obstack_next_free

_obstack_next_free:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_obstack_next_free
