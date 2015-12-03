
; size_t obstack_align_distance(struct obstack *ob, size_t alignment)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_align_distance

EXTERN asm_obstack_align_distance

obstack_align_distance:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_obstack_align_distance
