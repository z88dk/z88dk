
; int obstack_align_to_callee(struct obstack *ob, size_t alignment)

SECTION code_alloc_obstack

PUBLIC _obstack_align_to_callee

_obstack_align_to_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_align_to.asm"
