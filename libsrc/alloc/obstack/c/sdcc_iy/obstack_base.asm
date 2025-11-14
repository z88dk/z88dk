
; void *obstack_base(struct obstack *ob)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_base

EXTERN asm_obstack_base

_obstack_base:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_obstack_base
