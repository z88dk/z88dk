
; void *obstack_finish(struct obstack *ob)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_finish

EXTERN asm_obstack_finish

_obstack_finish:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_obstack_finish
