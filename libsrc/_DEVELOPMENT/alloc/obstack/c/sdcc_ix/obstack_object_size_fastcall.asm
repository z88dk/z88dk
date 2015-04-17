
; size_t obstack_object_size_fastcall(struct obstack *ob)

SECTION code_alloc_obstack

PUBLIC _obstack_object_size_fastcall

_obstack_object_size_fastcall:

   INCLUDE "alloc/obstack/z80/asm_obstack_object_size.asm"
