
; void *obstack_blank_fast(struct obstack *ob, int size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_blank_fast

EXTERN asm_obstack_blank_fast

_obstack_blank_fast:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_obstack_blank_fast
