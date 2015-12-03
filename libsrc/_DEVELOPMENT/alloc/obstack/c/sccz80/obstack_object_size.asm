
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t obstack_object_size(struct obstack *ob)
;
; Return the size in bytes of the currently growing object.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_object_size

EXTERN asm_obstack_object_size

defc obstack_object_size = asm_obstack_object_size
