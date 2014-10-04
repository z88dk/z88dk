
; void *obstack_copy0(struct obstack *ob, void *address, size_t size)

SECTION seg_code_obstack

PUBLIC _obstack_copy0

_obstack_copy0:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   INCLUDE "alloc/obstack/z80/asm_obstack_copy0.asm"
