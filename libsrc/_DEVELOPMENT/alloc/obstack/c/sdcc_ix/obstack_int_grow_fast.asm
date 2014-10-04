
; void *obstack_int_grow_fast(struct obstack *ob, int data)

SECTION seg_code_obstack

PUBLIC _obstack_int_grow_fast

_obstack_int_grow_fast:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_int_grow_fast.asm"
