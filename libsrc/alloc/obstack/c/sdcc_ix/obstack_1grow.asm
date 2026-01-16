
; void *obstack_1grow(struct obstack *ob, char c)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_1grow

EXTERN asm_obstack_1grow

_obstack_1grow:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_obstack_1grow
