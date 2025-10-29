
; int obstack_align_to_callee(struct obstack *ob, size_t alignment)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_align_to_callee

EXTERN asm_obstack_align_to

_obstack_align_to_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_obstack_align_to
