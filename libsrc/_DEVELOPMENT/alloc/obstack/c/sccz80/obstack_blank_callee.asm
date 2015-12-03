
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

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_blank_callee

EXTERN asm_obstack_blank

obstack_blank_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_obstack_blank
