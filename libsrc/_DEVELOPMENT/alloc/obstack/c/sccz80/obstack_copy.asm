
; void *obstack_copy(struct obstack *ob, void *address, size_t size)

PUBLIC obstack_copy

EXTERN asm_obstack_copy

obstack_copy:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   jp asm_obstack_copy
