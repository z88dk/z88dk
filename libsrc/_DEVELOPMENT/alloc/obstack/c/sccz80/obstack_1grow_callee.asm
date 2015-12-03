
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_1grow(struct obstack *ob, char c)
;
; Append char c to the growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_1grow_callee

EXTERN asm_obstack_1grow

obstack_1grow_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_obstack_1grow
