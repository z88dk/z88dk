
; int obstack_grow0_callee(struct obstack *ob, void *data, size_t size)

SECTION code_alloc_obstack

PUBLIC _obstack_grow0_callee

_obstack_grow0_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_grow0.asm"
