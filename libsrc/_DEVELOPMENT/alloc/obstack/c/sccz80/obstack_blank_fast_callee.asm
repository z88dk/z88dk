
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

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_blank_fast_callee

EXTERN asm_obstack_blank_fast

obstack_blank_fast_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_obstack_blank_fast
