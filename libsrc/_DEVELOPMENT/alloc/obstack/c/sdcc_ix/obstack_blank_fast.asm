
; void *obstack_blank_fast(struct obstack *ob, int size)

XDEF obstack_blank_fast

obstack_blank_fast:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_blank_fast.asm"
