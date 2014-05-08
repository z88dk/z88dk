
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t obstack_align_distance(struct obstack *ob, size_t alignment)
;
; Return distance in bytes from the obstack fence to the next
; address aligned to alignment.
;
; ===============================================================

PUBLIC obstack_align_distance_callee

obstack_align_distance_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "alloc/obstack/z80/asm_obstack_align_distance.asm"
