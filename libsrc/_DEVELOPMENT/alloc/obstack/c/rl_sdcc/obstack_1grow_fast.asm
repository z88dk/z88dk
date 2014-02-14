
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_1grow_fast(struct obstack *ob, char c)
;
; Append char c to the growing object, no bounds check made.
;
; ===============================================================

XDEF obstack_1grow_fast

obstack_1grow_fast:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld a,e

   INCLUDE "../../z80/asm_obstack_1grow_fast.asm"
