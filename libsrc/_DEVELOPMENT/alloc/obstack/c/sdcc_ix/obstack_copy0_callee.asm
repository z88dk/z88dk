
; void *obstack_copy0_callee(struct obstack *ob, void *address, size_t size)

SECTION code_alloc_obstack

PUBLIC _obstack_copy0_callee

_obstack_copy0_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

   INCLUDE "alloc/obstack/z80/asm_obstack_copy0.asm"
