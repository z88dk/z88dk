
; void *obstack_alloc_callee(struct obstack *ob, size_t size)

SECTION code_alloc_obstack

PUBLIC _obstack_alloc_callee

_obstack_alloc_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_alloc.asm"
