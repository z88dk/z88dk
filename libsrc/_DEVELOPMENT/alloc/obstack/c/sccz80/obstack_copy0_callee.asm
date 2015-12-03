
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_copy0(struct obstack *ob, void *address, size_t size)
;
; Attempt to allocate size+1 bytes from the obstack and initialize
; it by copying data from address, terminating the copy with a
; NUL char.  Implicitly closes any growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_copy0_callee

EXTERN asm_obstack_copy0

obstack_copy0_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_obstack_copy0
