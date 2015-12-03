
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_int_grow_fast(struct obstack *ob, int data)
;
; Append int to the growing object, no bounds check is made.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_int_grow_fast_callee

EXTERN asm_obstack_int_grow_fast

obstack_int_grow_fast_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_obstack_int_grow_fast
