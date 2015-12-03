
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

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_align_distance_callee

EXTERN asm_obstack_align_distance

obstack_align_distance_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_obstack_align_distance
