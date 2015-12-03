
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int obstack_grow0(struct obstack *ob, void *data, size_t size)
;
; Grow the current object by appending size bytes read from
; address data followed by a NUL char.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_grow0_callee

EXTERN asm_obstack_grow0

obstack_grow0_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_obstack_grow0
