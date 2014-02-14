
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_finish(struct obstack *ob)
;
; Return the address of the currently growing object and close
; it.  The next use of the grow functions will create a new
; object.
;
; If no object was growing, the returned address is the next
; free byte in the obstack and this should be treated as a
; zero length block.
;
; ===============================================================

XDEF obstack_finish

obstack_finish:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_obstack_finish.asm"
