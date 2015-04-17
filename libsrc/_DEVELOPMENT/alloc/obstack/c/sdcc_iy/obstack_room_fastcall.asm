
; size_t obstack_room_fastcall(struct obstack *ob)

SECTION code_alloc_obstack

PUBLIC _obstack_room_fastcall

_obstack_room_fastcall:

   INCLUDE "alloc/obstack/z80/asm_obstack_room.asm"
