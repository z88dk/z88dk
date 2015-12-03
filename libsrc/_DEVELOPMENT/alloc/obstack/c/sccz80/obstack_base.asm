
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_base(struct obstack *ob)
;
; Returns the address of the currently growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_base

EXTERN asm_obstack_base

defc obstack_base = asm_obstack_base
