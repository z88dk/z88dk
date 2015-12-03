
; size_t obstack_room_fastcall(struct obstack *ob)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_room_fastcall

EXTERN asm_obstack_room

defc _obstack_room_fastcall = asm_obstack_room
