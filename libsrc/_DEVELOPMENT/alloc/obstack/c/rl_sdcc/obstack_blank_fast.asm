
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_blank_fast(struct obstack *ob, int size)
;
; Resize the currently growing object by signed size bytes.  If
; the object grows, the extra space is uninitialized.
;
; No boundary checks are made.
;
; ===============================================================

XDEF obstack_blank_fast

obstack_blank_fast:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_obstack_blank_fast.asm"
