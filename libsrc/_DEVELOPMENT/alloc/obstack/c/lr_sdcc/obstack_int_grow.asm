
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
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_int_grow.asm"
