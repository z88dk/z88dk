
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_int_grow(struct obstack *ob, int data)
;
; Append int to the growing object.
;
; ===============================================================

XDEF obstack_int_grow_callee

obstack_int_grow_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "alloc/obstack/z80/asm_obstack_int_grow.asm"
