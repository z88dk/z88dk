
; void *obstack_int_grow(struct obstack *ob, int data)

SECTION seg_code_obstack

PUBLIC obstack_int_grow

EXTERN asm_obstack_int_grow

obstack_int_grow:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_int_grow
