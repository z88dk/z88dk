
; size_t obstack_align_distance(struct obstack *ob, size_t alignment)

XDEF _obstack_align_distance

_obstack_align_distance:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_align_distance.asm"
