
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_copy(struct obstack *ob, void *address, size_t size)
;
; Attempt to allocate size bytes from the obstack and initialize
; it by copying data from address.  Implicitly closes any growing
; object.
;
; ===============================================================

XDEF obstack_copy

obstack_copy:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   INCLUDE "../../z80/asm_obstack_copy.asm"
