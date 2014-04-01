
; void *obstack_alloc(struct obstack *ob, size_t size)

XDEF obstack_alloc

obstack_alloc:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_alloc.asm"
