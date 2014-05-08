
; int obstack_align_to(struct obstack *ob, size_t alignment)

PUBLIC obstack_align_to

EXTERN asm_obstack_align_to

obstack_align_to:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_align_to
