
; void *obstack_alloc(struct obstack *ob, size_t size)

XDEF _obstack_alloc

_obstack_alloc:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_alloc.asm"
