
; void *obstack_copy(struct obstack *ob, void *address, size_t size)

PUBLIC _obstack_copy

_obstack_copy:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   INCLUDE "alloc/obstack/z80/asm_obstack_copy.asm"
