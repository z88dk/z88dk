
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int obstack_grow(struct obstack *ob, void *data, size_t size)
;
; Grow the current object by appending size bytes read from
; address data.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_grow_callee

EXTERN asm_obstack_grow

obstack_grow_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_obstack_grow
