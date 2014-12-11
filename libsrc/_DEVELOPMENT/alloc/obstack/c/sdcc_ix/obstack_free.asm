
; void *obstack_free(struct obstack *ob, void *object)

SECTION code_alloc_obstack

PUBLIC _obstack_free

_obstack_free:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_free.asm"
