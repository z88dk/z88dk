
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_int_grow(struct obstack *ob, int data)
;
; Append int to the growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_int_grow_callee

EXTERN asm_obstack_int_grow

obstack_int_grow_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_obstack_int_grow
