
; size_t obstack_align_distance(struct obstack *ob, size_t alignment)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_align_distance

EXTERN asm_obstack_align_distance

_obstack_align_distance:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_obstack_align_distance
