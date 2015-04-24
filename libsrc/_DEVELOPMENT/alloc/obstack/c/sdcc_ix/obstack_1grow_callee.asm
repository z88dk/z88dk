
; void *obstack_1grow_callee(struct obstack *ob, char c)

SECTION code_alloc_obstack

PUBLIC _obstack_1grow_callee

_obstack_1grow_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_1grow.asm"
