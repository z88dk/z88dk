
; void *obstack_copy_callee(struct obstack *ob, void *address, size_t size)

SECTION code_alloc_obstack

PUBLIC _obstack_copy_callee

_obstack_copy_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

   INCLUDE "alloc/obstack/z80/asm_obstack_copy.asm"
