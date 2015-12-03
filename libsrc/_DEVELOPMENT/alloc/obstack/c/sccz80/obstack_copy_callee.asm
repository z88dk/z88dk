
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_copy(struct obstack *ob, void *address, size_t size)
;
; Attempt to allocate size bytes from the obstack and initialize
; it by copying data from address.  Implicitly closes any growing
; object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_copy_callee

EXTERN asm_obstack_copy

obstack_copy_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_obstack_copy
