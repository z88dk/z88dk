
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_int_grow(struct obstack *ob, int data)
;
; Append int to the growing object.
;
; ===============================================================

XDEF obstack_int_grow

obstack_int_grow:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_obstack_int_grow.asm"
