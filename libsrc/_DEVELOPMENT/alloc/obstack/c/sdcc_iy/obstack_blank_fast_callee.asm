
; void *obstack_blank_fast_callee(struct obstack *ob, int size)

SECTION code_alloc_obstack

PUBLIC _obstack_blank_fast_callee

_obstack_blank_fast_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_blank_fast.asm"
