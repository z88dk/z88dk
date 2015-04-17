
; void *obstack_next_free_fastcall(struct obstack *ob)

SECTION code_alloc_obstack

PUBLIC _obstack_next_free_fastcall

_obstack_next_free_fastcall:

   INCLUDE "alloc/obstack/z80/asm_obstack_next_free.asm"
