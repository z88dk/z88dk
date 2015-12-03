
; void *obstack_blank_fast(struct obstack *ob, int size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_blank_fast

EXTERN asm_obstack_blank_fast

obstack_blank_fast:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_blank_fast
