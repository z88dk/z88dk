
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_copy0(struct obstack *ob, void *address, size_t size)
;
; Attempt to allocate size+1 bytes from the obstack and initialize
; it by copying data from address, terminating the copy with a
; NUL char.  Implicitly closes any growing object.
;
; ===============================================================

XDEF obstack_copy0

obstack_copy0:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   INCLUDE "../../z80/asm_obstack_copy0.asm"
