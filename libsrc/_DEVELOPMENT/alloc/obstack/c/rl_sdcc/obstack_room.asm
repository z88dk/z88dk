
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t obstack_room(struct obstack *ob)
;
; Number of free bytes available in the obstack.
;
; ===============================================================

XDEF obstack_room:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_obstack_room.asm"
