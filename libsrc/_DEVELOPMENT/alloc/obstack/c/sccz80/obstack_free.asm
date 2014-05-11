
; void *obstack_free(struct obstack *ob, void *object)

PUBLIC obstack_free

EXTERN asm_obstack_free

obstack_free:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_free
