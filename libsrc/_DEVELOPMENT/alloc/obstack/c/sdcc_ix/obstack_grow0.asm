
; int obstack_grow0(struct obstack *ob, void *data, size_t size)

SECTION code_alloc_obstack

PUBLIC _obstack_grow0

_obstack_grow0:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_grow0.asm"
