
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_free(struct obstack *ob, void *object)
;
; If object is part of the obstack, deallocate the object and
; all objects allocated after it.
;
; If object == NULL, completely empty the obstack.  The obstack
; is in a valid state and can continue to be used.
;
; On successful free, any growing object is closed and freed.
;
; ===============================================================

XDEF obstack_free

obstack_free:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_free.asm"
