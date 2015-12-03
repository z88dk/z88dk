
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_alloc(struct obstack *ob, size_t size)
;
; Allocate an uninitialized block of size bytes from the obstack.
; Implicitly closes and growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_alloc_callee

EXTERN asm_obstack_alloc

obstack_alloc_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_obstack_alloc
