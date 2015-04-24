
; void *obstack_1grow_fast_callee(struct obstack *ob, char c)

SECTION code_alloc_obstack

PUBLIC _obstack_1grow_fast_callee, l0_obstack_1grow_fast_callee

_obstack_1grow_fast_callee:

   pop af
   pop hl
   pop de
   push af

l0_obstack_1grow_fast_callee:

   ld a,e

   INCLUDE "alloc/obstack/z80/asm_obstack_1grow_fast.asm"
