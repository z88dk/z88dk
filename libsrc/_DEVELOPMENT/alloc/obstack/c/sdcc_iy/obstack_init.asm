
; void *obstack_init(struct obstack *ob, size_t size)

XDEF obstack_init

obstack_init:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_init.asm"
