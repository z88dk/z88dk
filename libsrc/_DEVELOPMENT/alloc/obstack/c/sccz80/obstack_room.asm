
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t obstack_room(struct obstack *ob)
;
; Number of free bytes available in the obstack.
;
; ===============================================================

PUBLIC obstack_room

obstack_room:

   INCLUDE "alloc/obstack/z80/asm_obstack_room.asm"
