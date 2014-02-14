
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t obstack_align_distance(struct obstack *ob, size_t alignment)
;
; Return distance in bytes from the obstack fence to the next
; address aligned to alignment.
;
; ===============================================================

XDEF obstack_align_distance

obstack_align_distance:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_obstack_align_distance.asm"
