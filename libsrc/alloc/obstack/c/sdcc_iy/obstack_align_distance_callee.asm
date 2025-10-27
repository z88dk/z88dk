
; size_t obstack_align_distance_callee(struct obstack *ob, size_t alignment)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_align_distance_callee

EXTERN asm_obstack_align_distance

_obstack_align_distance_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_obstack_align_distance
