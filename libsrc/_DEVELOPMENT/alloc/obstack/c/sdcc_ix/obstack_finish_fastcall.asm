
; void *obstack_finish_fastcall(struct obstack *ob)

SECTION code_alloc_obstack

PUBLIC _obstack_finish_fastcall

_obstack_finish_fastcall:

   INCLUDE "alloc/obstack/z80/asm_obstack_finish.asm"
