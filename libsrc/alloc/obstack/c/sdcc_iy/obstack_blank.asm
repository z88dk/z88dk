
; void *obstack_blank(struct obstack *ob, int size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_blank

EXTERN asm_obstack_blank

_obstack_blank:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_obstack_blank
