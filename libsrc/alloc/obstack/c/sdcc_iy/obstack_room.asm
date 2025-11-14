
; size_t obstack_room(struct obstack *ob)

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC _obstack_room

EXTERN asm_obstack_room

_obstack_room:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_obstack_room
