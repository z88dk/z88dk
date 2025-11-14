
; int obstack_align_to(struct obstack *ob, size_t alignment)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_align_to

EXTERN asm_obstack_align_to

_obstack_align_to:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_obstack_align_to
