
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_1grow_fast(struct obstack *ob, char c)
;
; Append char c to the growing object, no bounds check made.
;
; ===============================================================

PUBLIC obstack_1grow_fast_callee

obstack_1grow_fast_callee:

   pop hl
   pop de
   ex (sp),hl
   ld a,e
   
   INCLUDE "alloc/obstack/z80/asm_obstack_1grow_fast.asm"
