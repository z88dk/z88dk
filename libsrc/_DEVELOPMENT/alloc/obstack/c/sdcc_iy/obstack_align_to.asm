
; int obstack_align_to(struct obstack *ob, size_t alignment)

XDEF _obstack_align_to

_obstack_align_to:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_align_to.asm"
