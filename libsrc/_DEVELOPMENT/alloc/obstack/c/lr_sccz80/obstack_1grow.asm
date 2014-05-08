
; void *obstack_1grow(struct obstack *ob, char c)

PUBLIC obstack_1grow

EXTERN asm_obstack_1grow

obstack_1grow:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_1grow
