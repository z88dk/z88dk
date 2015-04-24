
; void *obstack_free_callee(struct obstack *ob, void *object)

SECTION code_alloc_obstack

PUBLIC _obstack_free_callee

_obstack_free_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_free.asm"
