
; void *obstack_base_fastcall(struct obstack *ob)

SECTION code_alloc_obstack

PUBLIC _obstack_base_fastcall

_obstack_base_fastcall:

   INCLUDE "alloc/obstack/z80/asm_obstack_base.asm"
