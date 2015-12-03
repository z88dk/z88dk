
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

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_free_callee

EXTERN asm_obstack_free

obstack_free_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_obstack_free
