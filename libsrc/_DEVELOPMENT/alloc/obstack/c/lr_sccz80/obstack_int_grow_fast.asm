
; void *obstack_int_grow_fast(struct obstack *ob, int data)

PUBLIC obstack_int_grow_fast

EXTERN asm_obstack_int_grow_fast

obstack_int_grow_fast:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_int_grow_fast
