
; void *obstack_init_callee(struct obstack *ob, size_t size)

SECTION code_alloc_obstack

PUBLIC _obstack_init_callee

_obstack_init_callee:

   pop af
   pop de
   pop bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_init.asm"
