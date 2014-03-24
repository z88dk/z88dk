
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_blank(struct obstack *ob, int size)
;
; Attempt to resize the currently growing object by
; signed size bytes.
;
; If size < 0, the object will not be allowed to shrink
; past its start address.
;
; If size > 0, additional bytes will be uninitialized.
;
; ===============================================================

XDEF obstack_blank

obstack_blank:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "alloc/obstack/z80/asm_obstack_blank.asm"
