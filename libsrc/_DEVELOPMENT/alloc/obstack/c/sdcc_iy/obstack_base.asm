
; void *obstack_base(struct obstack *ob)

SECTION seg_code_obstack

PUBLIC _obstack_base

_obstack_base:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/obstack/z80/asm_obstack_base.asm"
