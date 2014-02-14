
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int obstack_align_to(struct obstack *ob, size_t alignment)
;
; Set the obstack fence to the next address aligned to alignment.
; Any following allocations or further growth will begin at this
; address.  Does not close the currently growing object.
;
; ===============================================================

XDEF obstack_align_to_callee

obstack_align_to_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_obstack_align_to.asm"
