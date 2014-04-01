
; void *obstack_copy0(struct obstack *ob, void *address, size_t size)

XDEF obstack_copy0

obstack_copy0:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   INCLUDE "alloc/obstack/z80/asm_obstack_copy0.asm"
