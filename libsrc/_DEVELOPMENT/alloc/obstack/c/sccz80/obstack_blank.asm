
; void *obstack_blank(struct obstack *ob, int size)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_blank

EXTERN asm_obstack_blank

obstack_blank:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_blank
